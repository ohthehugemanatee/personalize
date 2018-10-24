#!/bin/bash

# take a screenshot, save it to Dropbox, copy the share link to the clipboard.
FILENAME=Screenshots/Screenshot_`date +%Y-%m-%d-%H.%M`.png

# Select an area and save the screenshot. We pass our arguments directly to gnome-screenshot
mkdir -p /tmp/Screenshots
gnome-screenshot -f "/tmp/${FILENAME}" "$*"
#URL=`dropbox sharelink "$FILENAME"`
cloud-dl -u "/tmp/${FILENAME}" Screenshots
URL=`cloud-dl -s "$FILENAME" -q`
echo $URL | xsel -ib

# Pop up a small notification
notify-send "Copied $URL to clipboard"
