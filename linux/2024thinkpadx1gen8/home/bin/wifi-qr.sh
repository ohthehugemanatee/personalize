#!/bin/bash

# Saves creds for the currently joined wifi network as a QR code.

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if ! [ -x "$(command -v qrencode)" ]; then
  sudo apt install qrencode
fi

SSID="$(iwgetid -r)"
SSID_PASS="$(sudo grep -r '^psk=' /etc/NetworkManager/system-connections/ | grep ${SSID} | cut -d'=' -f 2)"

qrencode -t PNG -o wifi.png "WIFI:S:${SSID};T:WPA2;P:${SSID_PASS};;"

open wifi.png

# Credit - https://feeding.cloud.geek.nz/posts/encoding-wifi-access-point-passwords-qr-code/
