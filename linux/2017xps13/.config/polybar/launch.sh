#!/bin/bash
# Launch polybar on each connected monitor.

(
  # File lock to prevent race conditions.
  flock 200
  # Terminate already running bar instances
  killall -q polybar
  # Wait until the processes have been shut down
  while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

  outputs=$(polybar --list-monitors | cut -d":" -f1)
  tray_output=eDP1

  for m in $outputs; do
    export MONITOR=$m
    export TRAY_POSITION=none
    if [[ $m == $tray_output ]]; then
      TRAY_POSITION=right
    fi
    polybar --reload mine < /dev/null > /var/tmp/polybar-$m.log 2>&1 200>&- &
    disown
  done
) 200> /var/tmp/polybar-launch.lock
