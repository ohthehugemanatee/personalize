#!/bin/sh

# Set i3wm workspace locations in a standard way. Arguments are the display names (${RIGHT}, DP1, etc) from left to right. Only works with two displays for now.

LEFT=$1
RIGHT=$2

echo "Setting i3 workspace positions."
if [ -x "$(command -v i3-msg)" ]; then
  I3MSG=$(which i3-msg)
  $I3MSG "workspace 1, move workspace to output ${LEFT}"
  $I3MSG "workspace 2, move workspace to output ${LEFT}"
  $I3MSG "workspace 3, move workspace to output ${LEFT}"
  $I3MSG "workspace 5, move workspace to output ${LEFT}"
  $I3MSG "workspace 6, move workspace to output ${RIGHT}"
  $I3MSG "workspace 7, move workspace to output ${RIGHT}"
  $I3MSG "workspace 8, move workspace to output ${RIGHT}"
  $I3MSG "workspace 9, move workspace to output ${RIGHT}"
  $I3MSG "workspace 0, move workspace to output ${RIGHT}"
fi;
