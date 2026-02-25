#!/usr/bin/env python3
"""
pomodoro-daemon.py — Enforced Pomodoro timer for sway/wayland.

Architecture:
  - Runs as a systemd user service
  - Enforces breaks by launching swaylock (vanilla) in a re-lock loop
  - USB key override: polls for a token file on a mounted USB device
  - Exposes state via unix socket for CLI control and waybar integration
  - Logs overrides and completed cycles

Author: Claude (Opus 4.6) for Campbell Vertesi
License: MIT
"""

import asyncio
import json
import logging
import os
import random
import signal
import subprocess
import sys
import time
from dataclasses import dataclass, field, asdict
from enum import Enum
from pathlib import Path
from typing import Optional

# ── Configuration ────────────────────────────────────────────────────────────

CONFIG_DIR = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "pomodoro-enforcer"
STATE_DIR = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state")) / "pomodoro-enforcer"
RUNTIME_DIR = Path(os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}"))
SOCKET_PATH = RUNTIME_DIR / "pomodoro-enforcer.sock"
STATE_FILE = STATE_DIR / "state.json"       # for waybar polling (low-overhead alternative to socket)
LOG_FILE = STATE_DIR / "pomodoro.log"

# USB override
USB_OVERRIDE_PATH = Path("/mnt/override-key/unlock.token")
USB_POLL_INTERVAL = 2  # seconds

# Default timings (seconds)
DEFAULT_WORK_DURATION = 25 * 60
DEFAULT_SHORT_BREAK = 5 * 60
DEFAULT_LONG_BREAK = 15 * 60
DEFAULT_CYCLES_BEFORE_LONG = 4

# Grace period: warning before lock engages (seconds)
LOCK_GRACE_PERIOD = 30


class Phase(str, Enum):
    IDLE = "idle"
    WORK = "work"
    GRACE = "grace"       # warning period before break lock
    BREAK_SHORT = "break_short"
    BREAK_LONG = "break_long"
    PAUSED = "paused"


@dataclass
class Config:
    work_duration: int = DEFAULT_WORK_DURATION
    short_break: int = DEFAULT_SHORT_BREAK
    long_break: int = DEFAULT_LONG_BREAK
    cycles_before_long: int = DEFAULT_CYCLES_BEFORE_LONG
    grace_period: int = LOCK_GRACE_PERIOD
    unlock_window: int = 60  # seconds before break end when password unlock is allowed
    background_dir: str = str(CONFIG_DIR / "backgrounds")  # dir of break images
    usb_override_path: str = str(USB_OVERRIDE_PATH)
    swaylock_extra_args: list = field(default_factory=list)

    @classmethod
    def load(cls):
        config_file = CONFIG_DIR / "config.json"
        if config_file.exists():
            with open(config_file) as f:
                data = json.load(f)
            return cls(**{k: v for k, v in data.items() if k in cls.__dataclass_fields__})
        return cls()

    def save(self):
        CONFIG_DIR.mkdir(parents=True, exist_ok=True)
        with open(CONFIG_DIR / "config.json", "w") as f:
            json.dump(asdict(self), f, indent=2)


@dataclass
class State:
    phase: Phase = Phase.IDLE
    cycle: int = 0              # current cycle (1-indexed when running)
    total_completed: int = 0    # total work sessions completed today
    phase_start: float = 0.0    # timestamp when current phase started
    phase_duration: float = 0.0 # how long current phase should last
    overrides_today: int = 0    # USB overrides used today
    enabled: bool = False       # master on/off
    paused_phase: Optional[str] = None  # phase we were in when paused
    paused_remaining: float = 0.0       # time remaining when paused

    def remaining(self) -> float:
        if self.phase == Phase.PAUSED:
            return self.paused_remaining
        if self.phase == Phase.IDLE:
            return 0
        elapsed = time.time() - self.phase_start
        return max(0, self.phase_duration - elapsed)

    def to_dict(self) -> dict:
        d = {
            "phase": self.phase.value,
            "cycle": self.cycle,
            "total_completed": self.total_completed,
            "remaining_seconds": round(self.remaining()),
            "remaining_formatted": self._format_remaining(),
            "overrides_today": self.overrides_today,
            "enabled": self.enabled,
        }
        return d

    def _format_remaining(self) -> str:
        r = int(self.remaining())
        m, s = divmod(r, 60)
        return f"{m:02d}:{s:02d}"

    def to_waybar(self, unlock_window: int = 0) -> dict:
        """Output format for waybar custom module (JSON)."""
        phase = self.phase.value
        remaining = self._format_remaining()
        if not self.enabled:
            return {"text": "🍅 off", "tooltip": "Pomodoro disabled", "class": "disabled"}
        if self.phase == Phase.IDLE:
            return {"text": "🍅 ready", "tooltip": "Pomodoro ready — click to start", "class": "idle"}
        if self.phase == Phase.WORK:
            return {
                "text": f"🍅 {remaining}",
                "tooltip": f"Work session {self.cycle} — {remaining} remaining",
                "class": "work",
            }
        if self.phase == Phase.GRACE:
            return {
                "text": f"⏸️ {remaining}",
                "tooltip": f"Break starting in {remaining} — save your work!",
                "class": "grace",
            }
        if self.phase in (Phase.BREAK_SHORT, Phase.BREAK_LONG):
            kind = "Long break" if self.phase == Phase.BREAK_LONG else "Short break"
            r = self.remaining()
            if unlock_window and r <= unlock_window:
                unlock_note = " (password unlock available)"
            elif unlock_window:
                enforced_remaining = int(r - unlock_window)
                m, s = divmod(enforced_remaining, 60)
                unlock_note = f" (unlock in {m:02d}:{s:02d})"
            else:
                unlock_note = ""
            return {
                "text": f"☕ {remaining}",
                "tooltip": f"{kind} — {remaining} remaining{unlock_note}",
                "class": "break",
            }
        if self.phase == Phase.PAUSED:
            return {
                "text": f"🍅 ⏸ {remaining}",
                "tooltip": f"Paused — {remaining} remaining",
                "class": "paused",
            }
        return {"text": "🍅 ?", "tooltip": "Unknown state", "class": "unknown"}


class PomodoroEnforcer:
    def __init__(self):
        self.config = Config.load()
        self.state = State()
        self.swaylock_proc: Optional[asyncio.subprocess.Process] = None
        self._phase_task: Optional[asyncio.Task] = None
        self._usb_task: Optional[asyncio.Task] = None
        self._state_writer_task: Optional[asyncio.Task] = None
        self._break_ending: bool = False  # set True to tell guard loop to stop
        self.logger = self._setup_logging()

    def _setup_logging(self) -> logging.Logger:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        logger = logging.getLogger("pomodoro")
        logger.setLevel(logging.INFO)
        fh = logging.FileHandler(LOG_FILE)
        fh.setFormatter(logging.Formatter("%(asctime)s [%(levelname)s] %(message)s"))
        logger.addHandler(fh)
        sh = logging.StreamHandler()
        sh.setFormatter(logging.Formatter("[%(levelname)s] %(message)s"))
        logger.addHandler(sh)
        return logger

    # ── Phase transitions ────────────────────────────────────────────────

    async def start(self):
        """Start or restart the Pomodoro cycle."""
        self.state.enabled = True
        self.state.cycle = 1
        self.logger.info("Pomodoro started")
        await self._enter_work()

    async def stop(self):
        """Stop and reset to idle."""
        self.state.enabled = False
        self.state.phase = Phase.IDLE
        self.state.cycle = 0
        if self._phase_task:
            self._phase_task.cancel()
        await self._kill_swaylock()
        self.logger.info("Pomodoro stopped")
        await self._write_state()

    async def pause(self):
        """Pause current phase."""
        if self.state.phase in (Phase.WORK, Phase.GRACE):
            self.state.paused_phase = self.state.phase.value
            self.state.paused_remaining = self.state.remaining()
            self.state.phase = Phase.PAUSED
            if self._phase_task:
                self._phase_task.cancel()
            self.logger.info(f"Paused with {self.state.paused_remaining:.0f}s remaining")
            await self._write_state()
        elif self.state.phase in (Phase.BREAK_SHORT, Phase.BREAK_LONG):
            return "Cannot pause during break — take the break!"

    async def resume(self):
        """Resume from pause."""
        if self.state.phase != Phase.PAUSED:
            return
        phase = Phase(self.state.paused_phase)
        remaining = self.state.paused_remaining
        self.state.phase = phase
        self.state.phase_start = time.time()
        self.state.phase_duration = remaining
        self.state.paused_phase = None
        self.state.paused_remaining = 0
        self.logger.info(f"Resumed {phase.value} with {remaining:.0f}s remaining")
        self._phase_task = asyncio.create_task(self._phase_timer(remaining))

    async def skip(self):
        """Skip current phase (advance to next)."""
        if self.state.phase == Phase.WORK:
            self.logger.info("Skipping work phase")
            await self._enter_grace()
        elif self.state.phase == Phase.GRACE:
            self.logger.info("Skipping grace period")
            await self._enter_break()
        elif self.state.phase in (Phase.BREAK_SHORT, Phase.BREAK_LONG):
            self.logger.info("Skipping break (manual)")
            await self._end_break()
        elif self.state.phase == Phase.PAUSED:
            await self.resume()

    async def toggle(self):
        """Toggle between started and stopped."""
        if self.state.enabled and self.state.phase != Phase.IDLE:
            await self.stop()
        else:
            await self.start()

    def _cancel_phase_task(self):
        """Cancel the current phase timer if it isn't the calling task."""
        current = asyncio.current_task()
        if self._phase_task and self._phase_task is not current and not self._phase_task.done():
            self._phase_task.cancel()
        self._phase_task = None

    async def _enter_work(self):
        """Begin a work session."""
        self._cancel_phase_task()
        self.state.phase = Phase.WORK
        self.state.phase_start = time.time()
        self.state.phase_duration = self.config.work_duration
        self.logger.info(f"Work session {self.state.cycle} started ({self.config.work_duration // 60}min)")
        await self._notify("🍅 Work session started", f"Session {self.state.cycle} — {self.config.work_duration // 60} minutes")
        self._phase_task = asyncio.create_task(self._phase_timer(self.config.work_duration))

    async def _enter_grace(self):
        """Grace period before screen lock."""
        self._cancel_phase_task()
        self.state.phase = Phase.GRACE
        self.state.phase_start = time.time()
        self.state.phase_duration = self.config.grace_period
        self.logger.info(f"Grace period ({self.config.grace_period}s)")
        await self._notify(
            "⏸️ Break in 30 seconds",
            "Save your work! Screen will lock for break.",
            urgency="critical"
        )
        self._phase_task = asyncio.create_task(self._phase_timer(self.config.grace_period))

    async def _enter_break(self):
        """Lock screen and start break."""
        self._cancel_phase_task()
        self._break_ending = False
        is_long = (self.state.cycle % self.config.cycles_before_long == 0)
        duration = self.config.long_break if is_long else self.config.short_break
        self.state.phase = Phase.BREAK_LONG if is_long else Phase.BREAK_SHORT
        self.state.phase_start = time.time()
        self.state.phase_duration = duration
        kind = "Long" if is_long else "Short"
        self.logger.info(f"{kind} break started ({duration // 60}min)")

        await self._lock_screen()
        self._phase_task = asyncio.create_task(self._phase_timer(duration))

    async def _end_break(self):
        """Unlock screen, advance cycle."""
        self._break_ending = True
        await self._kill_swaylock()
        self.state.total_completed += 1
        self.state.cycle += 1
        self.logger.info(f"Break ended. Total completed: {self.state.total_completed}")
        await self._notify("🍅 Break over!", f"Session {self.state.cycle} starting")
        await self._enter_work()

    async def _phase_timer(self, duration: float):
        """Sleep for the phase duration, then trigger the next transition."""
        try:
            self.logger.info(f"Starting phase timer for {duration:.0f}s")
            await asyncio.sleep(duration)
        except asyncio.CancelledError:
            return

        if self.state.phase == Phase.WORK:
            await self._enter_grace()
        elif self.state.phase == Phase.GRACE:
            await self._enter_break()
        elif self.state.phase in (Phase.BREAK_SHORT, Phase.BREAK_LONG):
            await self._end_break()

    # ── Screen lock ──────────────────────────────────────────────────────

    _IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".bmp", ".gif", ".webp"}

    def _pick_background_image(self) -> Optional[str]:
        """Pick a random image from the background directory, or None."""
        bg_dir = Path(self.config.background_dir)
        if not bg_dir.is_dir():
            return None
        images = [
            f for f in bg_dir.iterdir()
            if f.is_file() and f.suffix.lower() in self._IMAGE_EXTENSIONS
        ]
        if not images:
            return None
        chosen = random.choice(images)
        self.logger.info(f"Break background: {chosen.name}")
        return str(chosen)

    def _swaylock_base_args(self) -> list:
        """Common vanilla swaylock arguments shared by all lock modes."""
        return [
            "swaylock",
            "--font", "monospace",
            "--indicator-radius", "120",
            "--indicator-thickness", "7",
            "--line-color", "00000000",
            "--separator-color", "00000000",
        ] + self.config.swaylock_extra_args

    def _swaylock_bg_args(self, image_path: Optional[str] = None) -> list:
        """Background arguments: image or solid color fallback."""
        if image_path:
            return ["--image", image_path, "--scaling", "fill"]
        # No image — solid color will be set by the enforced/unlockable cmd
        return []

    def _swaylock_enforced_cmd(self, image_path: Optional[str] = None) -> list:
        """swaylock command for the enforced lock period (USB key required)."""
        return self._swaylock_base_args() + self._swaylock_bg_args(image_path) + [
            "--color", "1a1a2eff",                 # dark background (behind image or solo)
            "--inside-color", "1a1a2eff",
            "--ring-color", "f0a500ff",            # amber ring = enforced
            "--text-color", "f0a500ff",
            "--key-hl-color", "ff6b6bff",           # red flash on keypress
            "--inside-ver-color", "1a1a2eff",
            "--ring-ver-color", "ff6b6bff",          # red ring during verify
            "--text-ver-color", "ff6b6bff",
            "--text-wrong-color", "ff6b6bff",
            "--indicator-idle-visible",
        ]

    def _swaylock_unlockable_cmd(self, image_path: Optional[str] = None) -> list:
        """swaylock command for the unlock window (password accepted)."""
        return self._swaylock_base_args() + self._swaylock_bg_args(image_path) + [
            "--color", "0f2b1fff",                  # dark green background
            "--inside-color", "0f2b1fff",
            "--ring-color", "2dcc70ff",             # green ring = unlockable
            "--text-color", "2dcc70ff",
            "--key-hl-color", "00d4ffff",           # cyan flash on keypress
            "--inside-ver-color", "0f2b1fff",
            "--ring-ver-color", "00d4ffff",
            "--text-ver-color", "00d4ffff",
            "--text-wrong-color", "ff6b6bff",
            "--indicator-idle-visible",
        ]

    async def _lock_screen(self):
        """Launch swaylock and manage the enforced → unlockable transition."""
        self.logger.info("Locking screen with swaylock")

        # Pick one background image for this entire break
        image_path = self._pick_background_image()

        self._usb_task = asyncio.create_task(self._poll_usb_override())
        asyncio.create_task(self._swaylock_guard(image_path))

    async def _swaylock_guard(self, image_path: Optional[str] = None):
        """Manage swaylock lifecycle through enforced and unlockable phases.

        Break structure:
          [0 ─── enforced (amber, re-lock) ─── T-unlock_window ─── unlockable (green) ─── T]
        """
        transitioned_to_unlockable = False

        while self.state.phase in (Phase.BREAK_SHORT, Phase.BREAK_LONG) and not self._break_ending:
            remaining = self.state.remaining()
            in_unlock_window = remaining <= self.config.unlock_window

            if in_unlock_window and not transitioned_to_unlockable:
                transitioned_to_unlockable = True
                self.logger.info("Entering unlock window — switching to green lock screen")
                await self._notify(
                    "🔓 Password unlock available",
                    "You can now unlock with your password",
                    urgency="normal"
                )

            if in_unlock_window:
                cmd = self._swaylock_unlockable_cmd(image_path)
            else:
                cmd = self._swaylock_enforced_cmd(image_path)

            try:
                self.logger.info(f"Launching swaylock (enforced={not in_unlock_window})")
                self.swaylock_proc = await asyncio.create_subprocess_exec(
                    *cmd,
                    stdin=asyncio.subprocess.DEVNULL,
                    stdout=asyncio.subprocess.DEVNULL,
                    stderr=asyncio.subprocess.DEVNULL,
                )

                transition_task = None
                if not in_unlock_window:
                    time_until_unlockable = remaining - self.config.unlock_window
                    if time_until_unlockable > 0:
                        transition_task = asyncio.create_task(
                            self._schedule_swaylock_transition(time_until_unlockable)
                        )

                await self.swaylock_proc.wait()

                if transition_task is not None:
                    transition_task.cancel()

                # swaylock exited — figure out why
                if self._break_ending:
                    break  # USB override or timer ended the break

                if self.state.phase not in (Phase.BREAK_SHORT, Phase.BREAK_LONG):
                    break  # phase already changed

                # User unlocked manually. Check which window we're in.
                remaining = self.state.remaining()
                if remaining <= self.config.unlock_window:
                    self.logger.info(
                        f"User unlocked in final {self.config.unlock_window}s window "
                        f"({remaining:.0f}s remaining) — ending break"
                    )
                    await self._end_break()
                    return
                else:
                    self.logger.info(
                        f"User unlocked during enforced period "
                        f"({remaining:.0f}s remaining) — re-locking"
                    )
                    await asyncio.sleep(0.5)
            except asyncio.CancelledError:
                break

    async def _schedule_swaylock_transition(self, delay: float):
        """Wait, then unlock swaylock so the guard loop restarts it with new visuals."""
        try:
            await asyncio.sleep(delay)
            if self.swaylock_proc and self.swaylock_proc.returncode is None:
                self.logger.info("Transition timer fired — restarting swaylock with unlock visuals")
                self.swaylock_proc.send_signal(signal.SIGUSR1)
        except asyncio.CancelledError:
            pass

    async def _kill_swaylock(self):
        """Terminate swaylock gracefully via SIGUSR1 (unlock and exit)."""
        if self._usb_task:
            self._usb_task.cancel()
            self._usb_task = None
        if self.swaylock_proc and self.swaylock_proc.returncode is None:
            self.swaylock_proc.send_signal(signal.SIGUSR1)
            try:
                await asyncio.wait_for(self.swaylock_proc.wait(), timeout=3)
            except asyncio.TimeoutError:
                self.logger.error("swaylock did not exit on SIGUSR1, sending again + SIGKILL fallback")
                try:
                    self.swaylock_proc.send_signal(signal.SIGUSR1)
                except ProcessLookupError:
                    pass
                try:
                    self.swaylock_proc.kill()
                except ProcessLookupError:
                    pass
            self.logger.info("swaylock terminated")
        self.swaylock_proc = None

    # ── USB override ─────────────────────────────────────────────────────

    async def _poll_usb_override(self):
        """Poll for USB override token during breaks."""
        override_path = Path(self.config.usb_override_path)
        try:
            while self.state.phase in (Phase.BREAK_SHORT, Phase.BREAK_LONG):
                if override_path.exists():
                    self.logger.info(f"USB override detected at {override_path}")
                    self.state.overrides_today += 1
                    await self._notify(
                        "🔑 USB Override",
                        f"Break overridden (override #{self.state.overrides_today} today)"
                    )
                    try:
                        override_path.unlink()
                    except OSError:
                        pass
                    await self._end_break()
                    return
                await asyncio.sleep(USB_POLL_INTERVAL)
        except asyncio.CancelledError:
            pass

    # ── Notifications ────────────────────────────────────────────────────

    async def _notify(self, summary: str, body: str = "", urgency: str = "normal"):
        """Send desktop notification via notify-send."""
        cmd = ["notify-send", "--urgency", urgency, "--app-name", "Pomodoro", summary]
        if body:
            cmd.append(body)
        try:
            proc = await asyncio.create_subprocess_exec(
                *cmd,
                stdout=asyncio.subprocess.DEVNULL,
                stderr=asyncio.subprocess.DEVNULL,
            )
            await proc.wait()
        except FileNotFoundError:
            self.logger.warning("notify-send not found — notifications disabled")

    # ── State file (for waybar) ──────────────────────────────────────────

    async def _write_state(self):
        """Write current state to file for waybar to read."""
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        try:
            data = json.dumps(self.state.to_waybar(self.config.unlock_window))
            STATE_FILE.write_text(data)
        except Exception as e:
            self.logger.error(f"Failed to write state: {e}")

    async def _state_writer_loop(self):
        """Continuously update the state file."""
        while True:
            await self._write_state()
            await asyncio.sleep(1)

    # ── Unix socket server ───────────────────────────────────────────────

    async def handle_client(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter):
        """Handle a single client connection on the unix socket."""
        try:
            data = await asyncio.wait_for(reader.readline(), timeout=5)
            command = data.decode().strip()

            response = await self._handle_command(command)
            writer.write((json.dumps(response) + "\n").encode())
            await writer.drain()
        except Exception as e:
            self.logger.error(f"Client error: {e}")
        finally:
            writer.close()
            await writer.wait_closed()

    async def _handle_command(self, command: str) -> dict:
        """Process a control command."""
        cmd_parts = command.split()
        if not cmd_parts:
            return {"error": "empty command"}

        cmd = cmd_parts[0]

        if cmd == "status":
            return self.state.to_dict()
        elif cmd == "waybar":
            return self.state.to_waybar(self.config.unlock_window)
        elif cmd == "start":
            await self.start()
            return {"ok": True, "phase": self.state.phase.value}
        elif cmd == "stop":
            await self.stop()
            return {"ok": True, "phase": self.state.phase.value}
        elif cmd == "pause":
            result = await self.pause()
            if result:
                return {"error": result}
            return {"ok": True, "phase": self.state.phase.value}
        elif cmd == "resume":
            await self.resume()
            return {"ok": True, "phase": self.state.phase.value}
        elif cmd == "skip":
            await self.skip()
            return {"ok": True, "phase": self.state.phase.value}
        elif cmd == "toggle":
            await self.toggle()
            return {"ok": True, "phase": self.state.phase.value}
        elif cmd == "config":
            return asdict(self.config)
        elif cmd == "set" and len(cmd_parts) >= 3:
            key, value = cmd_parts[1], cmd_parts[2]
            if hasattr(self.config, key):
                try:
                    setattr(self.config, key, int(value))
                    self.config.save()
                    return {"ok": True, "key": key, "value": int(value)}
                except ValueError:
                    return {"error": f"invalid value: {value}"}
            return {"error": f"unknown config key: {key}"}
        else:
            return {"error": f"unknown command: {cmd}",
                    "commands": ["status", "waybar", "start", "stop", "pause",
                                 "resume", "skip", "toggle", "config", "set <key> <value>"]}

    # ── Main loop ────────────────────────────────────────────────────────

    async def run(self):
        """Start the daemon."""
        if SOCKET_PATH.exists():
            SOCKET_PATH.unlink()

        server = await asyncio.start_unix_server(self.handle_client, path=str(SOCKET_PATH))
        os.chmod(SOCKET_PATH, 0o600)

        self.logger.info(f"Pomodoro daemon started, socket: {SOCKET_PATH}")

        self._state_writer_task = asyncio.create_task(self._state_writer_loop())

        loop = asyncio.get_event_loop()
        for sig in (signal.SIGTERM, signal.SIGINT):
            loop.add_signal_handler(sig, lambda: asyncio.create_task(self._shutdown(server)))

        async with server:
            await server.serve_forever()

    async def _shutdown(self, server):
        """Clean shutdown."""
        self.logger.info("Shutting down...")
        await self._kill_swaylock()
        if self._phase_task:
            self._phase_task.cancel()
        if self._state_writer_task:
            self._state_writer_task.cancel()
        server.close()
        if SOCKET_PATH.exists():
            SOCKET_PATH.unlink()
        self.state.phase = Phase.IDLE
        self.state.enabled = False
        await self._write_state()
        sys.exit(0)


def main():
    enforcer = PomodoroEnforcer()
    asyncio.run(enforcer.run())


if __name__ == "__main__":
    main()
