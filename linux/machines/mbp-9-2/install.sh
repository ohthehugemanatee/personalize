#!/bin/bash

# Installs the settings I need for the Macbook Pro 9,2

mkdir -p /etc/X11/xorg.conf.d
ln -s $PWD/etc/x11/xorg.conf.d/60-synaptics.conf /etc/X11/xorg.conf.d/60-synaptics.conf

sudo apt install xbacklight -y

sudo ln -s $PWD/usr/local/bin/kb /usr/local/bin/kb
sudo ln -s $PWD/usr/local/bin/say /usr/local/bin/say

# Get the mbpfan tool from github, make install, and add the service
SCRIPT_DIR=$PWD
cd /tmp
/usr/bin/wget https://github.com/dgraziotin/mbpfan/archive/master.zip
unzip master.zip
cd /tmp/mbpfan-master
sudo apt install build-essential -y
make && sudo make install && sudo make tests
sudo mv /etc/mbpfan.conf /etc/mbpfan.conf.bak
sudo ln -s $SCRIPT_DIR/etc/mbpfan.conf /etc/mbpfan.conf
sudo cp mbpfan.service /etc/systemd/system/
sudo systemctl enable mbpfan.service
sudo service mbpfan start

# Add special udev rule for changing the sense of the Fn key when there's an external mac keyboard plugged in.
cd $SCRIPT_DIR
sudo ln -s $SCRIPT_DIR/toggle-fn.sh /usr/local/sbin
sudo ln -s $SCRIPT_DIR/etc/udev/rules.d/* /etc/udev/rules.d
sudo service udev restart
