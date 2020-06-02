#!/bin/bash

# Toggles systemd start/stop for rot8 screen rotation service.

if [ $(systemctl --user is-active rot8) == "active" ]; then
  systemctl --user stop rot8
else
  systemctl --user start rot8
fi
