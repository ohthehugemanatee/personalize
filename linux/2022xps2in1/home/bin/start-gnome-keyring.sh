#!/bin/sh

if [ -n "$DESKTOP_SESSION" ];then
      eval $(gnome-keyring-daemon --components=secrets --start)
      echo "Started gnome-keyring-daemon"
fi

