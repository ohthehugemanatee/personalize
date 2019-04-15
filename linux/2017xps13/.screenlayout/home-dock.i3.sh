#!/bin/sh

# Set i3wm workspace locations on the home dock environment.

echo "Setting i3 workspace positions."
if [ -x "$(command -v i3-msg)" ]; then
  I3MSG=$(which i3-msg)
  $I3MSG "workspace 1, move workspace to output DP2-1"
  $I3MSG "workspace 2, move workspace to output DP2-1"
  $I3MSG "workspace 3, move workspace to output DP2-1"
  $I3MSG "workspace 4, move workspace to output DP1-2"
  $I3MSG "workspace 5, move workspace to output DP1-2"
  $I3MSG "workspace 6, move workspace to output DP1-2"
  $I3MSG "workspace 7, move workspace to output eDP1"
  $I3MSG "workspace 8, move workspace to output eDP1"
  $I3MSG "workspace 9, move workspace to output eDP1"
  $I3MSG "workspace 0, move workspace to output eDP1"
fi;
