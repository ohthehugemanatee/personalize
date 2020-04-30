#!/bin/bash

# Take a screenshot, save it to Nextcloud, copy the share link to the clipboard.
# Adapted for Wayland.

# Filename format.
FILENAME=Screenshots/Screenshot_`date +%Y-%m-%d-%H.%M.%S`.png
NEXTCLOUD=$HOME/Nextcloud

# Tmpdir for screenshots.
mkdir -p /tmp/Screenshots

# Select an area and save the screenshot. We pass our arguments directly to grim

# Screenshot the active output only
CMD="grim" 

while getopts "osc" OPTION
do
	case $OPTION in
		o) # capture an output to file
			${CMD} -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" "${NEXTCLOUD}/${FILENAME}"
			MSG="Captured ${NEXTCLOUD}/${FILENAME}"
			;;
		s) # capture selection to file
			${CMD} -g "$(slurp)" "${NEXTCLOUD}/${FILENAME}"
			MSG="Captured ${NEXTCLOUD}/${FILENAME}"
			;;
		c) # capture selection to clipboard
			${CMD} -g "$(slurp)" - | wl-copy --type "image/png"
			MSG="Captured selection to clipboard"
			;;
		\?)
			echo "Flag options:"
			echo "-o  Captures output to file."
			echo "-s  Captures selection to file."
			echo "-c  Captures selection to clipboard."
			exit
			;;
	esac
done
notify-send "${MSG}"
echo "${MSG}"
exit

