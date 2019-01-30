#!/bin/bash

# take a screenshot, save it to Dropbox, copy the share link to the clipboard.
FILENAME=Screenshots/Screenshot_`date +%Y-%m-%d-%H.%M.%S`.png

# Select an area and save the screenshot. We pass our arguments directly to gnome-screenshot

# If we're saving to a file.
if [[ $* != *c* ]]; then
  mkdir -p /tmp/Screenshots
  gnome-screenshot -f "/tmp/${FILENAME}" "$*"
  # Add to nextcloud.
  cloud-dl -u "/tmp/${FILENAME}" Screenshots
  URL=`cloud-dl -s "$FILENAME" -q`
  echo $URL | xsel -ib
else
  # Remove -c parameter and save it as a file anyway.
  PARAMS=${*//c}
  echo $PARAMS
  gnome-screenshot -f "/tmp/${FILENAME}" "$PARAMS"
  # Pass the file into the clipboard with the mime type.
  xclip -selection clipboard -t "image/png" < /tmp/${FILENAME}
  URL='screenshot'
fi

# Pop up a small notification
notify-send "Copied $URL to clipboard"
