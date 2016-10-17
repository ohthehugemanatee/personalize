#!/bin/bash

# Installs the settings I need for the Macbook Pro 9,2

mkdir -p /etc/X11/xorg.conf.d
ln -s $PWD/etc/x11/xorg.conf.d/60-synaptics.conf /etc/X11/xorg.conf.d/60-synaptics.conf

sudo apt install xbacklight -y

sudo ln -s $PWD/usr/local/bin/kb /usr/local/bin/kb
sudo ln -s $PWD/usr/local/bin/say /usr/local/bin/say
