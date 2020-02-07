#!/bin/sh
xrandr \
  --output eDP-1 --primary --mode 3840x2400 --scale "1.3x1.3" --pos 4705x3456 --rotate normal \
	--output DP-4-2 --mode 3440x1440 --scale "2.4x2.4" --pos 4608x0 --auto --rotate normal \
	--output DP-3 --mode 1920x1080 --scale "2.4x2.4" --pos 0x1473 --rotate normal \
	--output DP-4 --off \
	--output DP-4-1 --off \
	--output DP-4-3 --off \
	--output DP-1 --off \
	--output DP-2 --off
