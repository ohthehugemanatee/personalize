#!/bin/bash
set -eu

# A little scrpit for when NetworkManager is fucking up a captive portal connection and I want to join manually.

# Args: ssid

# must be run as root.

echo "Stoppig network mnager"
systemctl stop NetworkManager
echo "bringing up network device"
ifconfig wlp0s20f3 up
echo "Connecting to SSID ${1}"
iwconfig wlp0s20f3 essid "${1}"
echo "Getting dhcp lease"
dhclient -v wlp0s20f3 
echo "Overwriting resolv.conf"
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "All done!"
