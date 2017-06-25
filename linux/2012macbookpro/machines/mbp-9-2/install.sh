#!/bin/bash

# Installs the settings I need for the Macbook Pro 9,2

SCRIPT_DIR=$PWD

#trackpad setup
mkdir -p /etc/X11/xorg.conf.d
ln -s $PWD/etc/x11/xorg.conf.d/60-trackpad.conf /etc/X11/xorg.conf.d/60-trackpad.conf

# install the "light" command from github to control screen brightness
cd /tmp
git clone https://github.com/haikarainen/light.git
cd light
make && sudo make install

# keyboard backlight brightness script
sudo ln -s $PWD/usr/local/bin/kb /usr/local/bin/kb
# voice synthesis
sudo ln -s $PWD/usr/local/bin/say /usr/local/bin/say

# Get the mbpfan tool from github, make install, and add the service
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

# Add power savings stuff.
sudo apt install powertop tlp tlp-rdw -y
sudo mv /etc/rc.local /etc/rc.local.bak
sudo ln -s $SCRIPT_DIR/linux/machines/mbp-9-2/etc/rc.local /etc/rc.local
cd $SCRIPT_DIR/power
sudo install 99-savings /etc/pm/sleep.d
sudo install 99-savings /etc/pm/power.d

echo "You may also consider modfying the values in /etc/UPower/UPower.conf for when the kernel should take action on low battery."

# add special modprobe options for the SD card reader and wireless card
# still necessary?
#sudo ln -s $SCRIPT_DIR/etc/modprobe.d/* /etc/modprobe.d
