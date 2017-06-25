#!/bin/bash

# Setup the system _just right_.


# Globals.
PERSONALIZE=$PWD
# Add my apt sources.
if [ -d /etc/apt/sources.list.d ]; then
  sudo ln -sf sources.list.d/* /etc/apt/sources.list.d/
fi
# Add some manual keys and repos.
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository ppa:numix/ppa # themes.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo add-apt-repository multiverse # various. Notably Steam.
sudo add-apt-repository ppa:ondrej/php

sudo apt update

# i3 desktop.
#
# 
# * I3 tiling window manager
# * i3 lock screen provider
# * i3 status bar provider
# * i3's dmenu menu provider
# * compton, i3 compatible compositor
# * xbacklight, for controlling screen backlight
# * feh, command line image viewer
# * conky, conky-manager for lightweight status widgets
# * pulseaudio and pa\* tools: audio interface and corresponding taskbar item
# * variety, wallpaper downloader/switcher
# * numlockx, numlock controller
# * lxappearance, GTK+ theme switcher
# * unclutter, hides the cursor when typing
# * terminator, alternative terminal emulator
# 
# A lot of the desktop setup comes from https://github.com/erikdubois/i3-on-Linux-Mint-18-Cinnamon.git and the corresponding blog post.

sudo apt install i3 i3lock suckless-tools i3status dmenu i3lock xbacklight feh conky pasystray paman paprefs pavumeter pulseaudio-module-zeroconf pavucontrol variety numlockx lxappearance xsel terminator -y

#simlink i3 config into place.
mkdir -p $HOME/.config
ln -sf $PERSONAlIZE/.config/i3 $HOME/.config/i3

#simlink conky library into place
ln -sf $PERSONAlIZE/.conky $HOME/.conky

#simlink screenshot script into place
sudo ln -sf $PERSONAlIZE/screenshot.sh /usr/local/bin/screenshot

# Installs applications and tools I like, want, and need.

sudo apt install -y php phpunit php-mbstring php-easyrdf openssh-server composer bundler ruby-dev cpupower cpufrequtils powertop gcc build-essential

sudo apt install -y dropbox steam

# Use Overlay FS for docker

sudo ln -sf $PERSONAlIZE/etc/docker/daemon.json /etc/docker/daemon.json

# Manual installs
echo "These applications must be manually installed from their websites. How crappy.

* Firefox developer edition
* Toggl
* PrivateInternetAccess
* Spotify"
