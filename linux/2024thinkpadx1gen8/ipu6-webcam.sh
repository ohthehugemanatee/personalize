#!/bin/bash

# built/tested on Ubuntu 24.04.4 LTS
sudo apt install gstreamer1.0-icamera libgsticamerainterface-1.0-1 # note libgsticamerainterface may need version pinning

# linux-modules-ipu6-*-generic should match the running kernel.
# the HWE meta-package should take care of this, but worst case
# you can use the Lenovo version: 
# `sudo apt install libgsticamerainterface-1.0-1=0~git202509260937.4fb31db~ubuntu24.04.4`

echo -e "ivsc-ace\nivsc-csi" | sudo tee /etc/modules-load.d/ivsc.conf 

echo 'SUBSYSTEM=="misc", KERNEL=="ipu-psys0", GROUP="video", MODE="0660"' | \
  sudo tee /etc/udev/rules.d/99-ipu6-psys.rules 

# Hides raw ipu6 nodes from non-pipewire apps
echo 'SUBSYSTEM=="video4linux", ATTR{name}=="Intel IPU6 ISYS Capture *", GROUP="root", MODE="0600"' | \
  sudo tee /etc/udev/rules.d/99-hide-ipu6-isys.rules
