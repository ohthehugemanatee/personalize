#!/bin/sh
xrandr \
  --output eDP-1 --primary --mode 3840x2400 --pos 1460x3312 --rotate normal \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --mode 3440x1440 --pos 0x0 --rotate normal --scale 2.3x2.3 \
  --output DP-4 --off
