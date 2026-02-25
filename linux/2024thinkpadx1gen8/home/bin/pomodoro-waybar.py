#!/usr/bin/env python3
"""
pomodoro-waybar.py — Waybar custom module for pomodoro-enforcer.

Outputs JSON for waybar's "custom" module type.
Designed to be called repeatedly by waybar (interval-based).

Also supports click actions:
  Left click:  toggle (start/stop)
  Right click: skip current phase
  Middle click: pause/resume
"""

import asyncio
import json
import os
import sys
from pathlib import Path

RUNTIME_DIR = Path(os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}"))
STATE_FILE = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state")) / "pomodoro-enforcer" / "state.json"
SOCKET_PATH = RUNTIME_DIR / "pomodoro-enforcer.sock"


async def send_command(command: str) -> dict:
    try:
        reader, writer = await asyncio.open_unix_connection(str(SOCKET_PATH))
        writer.write((command + "\n").encode())
        await writer.drain()
        data = await asyncio.wait_for(reader.readline(), timeout=2)
        writer.close()
        await writer.wait_closed()
        return json.loads(data.decode())
    except Exception:
        return None


def read_state_file() -> dict:
    """Fallback: read state from file if socket is slow."""
    try:
        return json.loads(STATE_FILE.read_text())
    except Exception:
        return {"text": "🍅 ??", "tooltip": "Daemon not running", "class": "error"}


def main():
    # If called with an argument, it's a click action
    if len(sys.argv) > 1:
        action = sys.argv[1]
        action_map = {
            "toggle": "toggle",
            "skip": "skip",
            "pause-resume": "pause" if True else "resume",  # daemon handles the logic
        }
        if action in action_map:
            asyncio.run(send_command(action_map[action]))
        return

    # Normal mode: output waybar JSON
    # Try socket first (authoritative), fall back to state file
    result = asyncio.run(send_command("waybar"))
    if result is None:
        result = read_state_file()

    print(json.dumps(result))


if __name__ == "__main__":
    main()
