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
MONITORS=$(xrandr -q | grep ' connected')
MONITOR_COUNT=$(xrandr -q | grep ' connected' | wc -l)
MONITOR_IDS=$(ls /sys/class/drm/*/edid | xargs -i{} sh -c "echo {}; parse-edid < {}" |grep ModelName)
echo "Monitor count is $MONITOR_COUNT"

# Either way, set the DPI.
#xrandr --dpi 221
if [ $MONITOR_COUNT -gt 1 ]; then
  xrandr --auto
  # Check for different combinations of monitors.
  if echo $MONITOR_IDS | grep -q 'C34H89x'; then
    echo "Found home curved monitor"
    $HOME/.screenlayout/big-home.sh
  fi;
  if echo $MONITORS | grep -q 'DVI-I-1-1'; then
    echo "Found MS workspace monitor"
    echo "No saved screenlayout yet. Starting arandr"
    /usr/bin/arandr
    #xrandr --fb 7040x2160
    #xrandr --output DVI-I-1-1 --scale 1x1 --mode 1920x1080 --pos 0x0
    #xrandr --output eDP1 --scale 1x1 --mode 3200x1800 --pos 3840x0
  fi;
  if echo $MONITOR_IDS | grep -q 'ASUS VS247'; then 
    echo "Found home workspace monitor"
    $HOME/.screenlayout/asus-home.sh
    #xrandr --fb 7040x2160
    #xrandr --output DP1 --scale 2x2 --mode 1920x1080 --pos 0x0
    #xrandr --output eDP1 --scale 1x1 --mode 3200x1800 --pos 3840x0
  fi;
  if echo $MONITOR_IDS |grep -q 'EA273WMi'; then
    echo "Found MS UdL desk monitor"
    $HOME/.screenlayout/ms-udl-desk.sh
  fi;
elif [ $MONITOR_COUNT = "1" ]; then
  xrandr --auto
fi
