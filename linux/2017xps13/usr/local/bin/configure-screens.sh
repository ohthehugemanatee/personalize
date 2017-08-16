#!/bin/bash

# A little script to position my 2 montior setup.
# You can always use xrandr to know the names of your monitors

# 1) Setup the DPI (fixed across the two monitors) and total size of the
# framebuffer area. You have to do the multiplication for the scale factor!
# Width is adding the two effective widths together: ((1920*2)+3840) = 7040.
# Height is the tallest pixel-height: (1080x2) > 1800, so height= 1080x2 = 2160.
# 2) Set the scale, resolutions, and positions of the two screens.
# Place the big monitor (DP1) at the very top left, and the small monitor 1920*2=3840px 
# to the right of it.

# Count connected monitors
MONITORS=$(xrandr -q | grep ' connected'|wc -l)

# Either way, set the DPI.
xrandr --dpi 221

if [ $MONITORS = "2" ]; then
  xrandr --fb 7040x2160
  xrandr --output DP1 --scale 2x2 --mode 1920x1080 --pos 0x0
  xrandr --output eDP1 --scale 1x1 --mode 3200x1800 --pos 3840x0
elif [ $MONITORS = "1" ]; then
  xrandr --auto
fi
