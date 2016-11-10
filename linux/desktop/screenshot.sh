#!/bin/bash

# take a screenshot, save it to Dropbox, copy the share link to the clipboard.
FILENAME=~/Dropbox/Screenshots/Screenshot_`date +%Y-%m-%d-%H.%M`.png

# Select an area and save the screenshot. We pass our arguments directly to gnome-screenshot
gnome-screenshot -f "$FILENAME" "$*"
#sleep 3 
URL=`dropbox sharelink "$FILENAME"`
echo $URL | xsel -ib

# Pop up a small notification
notify-send "Copied $URL to clipboard"
