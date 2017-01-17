#!/bin/bash

# Rescan wifi networks on resume.
# Intended to be added to /etc/pm/sleep.d

case $1 in
  "resume")
    iwlist scan
    ;;
  "thaw")
    iwlist scan
    ;;
esac
