#!/bin/bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Dim the screen after 120 seconds, undim if user becomes active` \
  --timer 120 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness .1' \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
  `# Undim & lock after 30 more seconds` \
  --timer 30 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; blurlock' \
    '' \
  `# Finally, suspend 30 mins after it locks` \
  --timer 1800 \
    'systemctl suspend' \
    ''
