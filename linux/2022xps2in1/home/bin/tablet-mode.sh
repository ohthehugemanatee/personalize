#!/bin/bash

# Executes behaviors for tablet mode and non-tablet mode, based on the single argument 'on' or 'off'.

# Enable tablet mode.
if [[ $1 == 'on' ]]; then
  notify-send "Tablet mode enabled"
  pkill waybar; waybar -b default -c "/home/ohthehugemanatee/.config/waybar/config.tablet.jsonc" -s "/home/ohthehugemanatee/.config/waybar/style.tablet.css"
  swaymsg eDP-1 scale 3
fi

# disable tablet mode
if [[ $1 == 'off' ]]; then
  notify-send "Tablet mode disabled"
  pkill waybar; waybar -b default -c "/home/ohthehugemanatee/.config/waybar/config.jsonc" -s "/home/ohthehugemanatee/.config/waybar/style.css"
  swaymsg eDP-1 scale 2
fi
