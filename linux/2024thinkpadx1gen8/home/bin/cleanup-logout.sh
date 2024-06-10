#!/bin/bash

# Cleanup tasks and log out of i3
/usr/bin/veracrypt -t --password=$(secret-tool lookup title veracrypt1) -d --non-interactive --use-dummy-sudo-password
i3exit logout
