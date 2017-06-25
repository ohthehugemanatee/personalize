#!/bin/bash

# Toggle the sense of the Fn key on a mac keyboard, ie whether it must be pressed for special functions. 

# Usage:
# toggle-fn.sh [value]
# Value is one of:
  # 0: completely disabled
  # 1: normal operation for a laptop, press Fn to use a normal F1-F12 number.
  # 2: reversed operation. Press Fn to use the special mac functions.

# Intended to be added to a udev rule, like /etc/udev/rules.d/85-toggle-fn.rules : 
# ACTION=="remove",SUBSYSTEMS=="usb",ATTRS{idVendor}=="05ac",ATTRS{idProduct}=="0221", RUN+="/usr/local/sbin/toggle-fn.sh 1"


# If there are no parameters provided, just toggle.
if [ $# -eq 0 ]; then
  if [ 1 = "$(cat /sys/module/hid_apple/parameters/fnmode)" ]; then
    echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
  else
    echo 1 | sudo tee /sys/module/hid_apple/parameters/fnmode
  fi
  # If there is a parameter provided, use that value.
else
  if ! [ "$1" -ge 0 -a "$1" -le 2 ]; then
    echo "The argument must be a number between 0 and 2."
  else
    echo $1 | sudo tee /sys/module/hid_apple/parameters/fnmode
  fi
fi

