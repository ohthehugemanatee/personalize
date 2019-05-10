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

xrandr --auto
case  $MONITOR_COUNT  in
  "3")
    # We've only got one config of 3 monitors... but check just in case.
    if [ `echo $MONITOR_IDS | grep -q 'C34H89X'` -a `echo $MONITOR_IDS | grep -q 'ASUS VS247'` ]; then
      echo "Found home docking station with two monitors."
      $HOME/.screenlayout/home-dock.sh
    fi;
    ;;
  "2")
    # Check for different combinations of monitors.
    if echo $MONITOR_IDS | grep -q 'C34H89x'; then
      echo "Found home curved monitor"
      $HOME/.screenlayout/big-home.sh
    fi;
    if echo $MONITORS | grep -q 'DVI-I-1-1'; then
      echo "Found MS workspace monitor"
      echo "No saved screenlayout yet. Starting arandr"
      /usr/bin/arandr
    fi;
    if echo $MONITOR_IDS | grep -q 'ASUS VS247'; then 
      echo "Found home workspace monitor"
      $HOME/.screenlayout/asus-home.sh
    fi;
    if echo $MONITOR_IDS |grep -q 'EA273WMi'; then
      echo "Found MS UdL desk monitor"
      $HOME/.screenlayout/ms-udl-desk.sh
    fi;
    ;;            
  "1")
    echo "Only the internal monitor was found."
    # No extra config necessary. `xrandr --auto` is enough.
    ;;
  *)              
esac 

