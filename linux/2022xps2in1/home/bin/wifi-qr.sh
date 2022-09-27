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

qrencode -t SVG -o wifi.svg "WIFI:S:${SSID};T:WPA2;P:${SSID_PASS};;"

xdg-open wifi.svg 

# Credit - https://feeding.cloud.geek.nz/posts/encoding-wifi-access-point-passwords-qr-code/
