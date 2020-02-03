#!/bin/sh
xrandr --output VIRTUAL1 --off --output eDP1 --off --output DP1 --mode 3440x1440 --pos 0x0 --rotate normal --output HDMI2 --off --output HDMI1 --off --output DP2 --off
# Allow the mouse on the full virtual screen width.
xrandr --output DP1 --panning 6880x2880 --dpi 221 --scale 2x2

