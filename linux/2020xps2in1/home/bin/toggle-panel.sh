#!/bin/bash

# Toggles the XFCE panel.
COMMAND="xfce4-panel"
if pgrep $COMMAND > /dev/null
then
  pkill $COMMAND
  pkill onboard
  exit 0
fi
setsid /usr/bin/xfce4-panel --disable-wm-check & > /dev/null
setsid /usr/bin/onboard & > /dev/null
exit 0
