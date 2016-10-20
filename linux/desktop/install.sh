#!/bin/bash

# Installs packages and configs for my desktop environment.

# See README.md for an explanation of each tool.
sudo add-apt-repository -y ppa:teejee2008/ppa

sudo apt install i3 i3lock suckless-tools i3status dmenu i3lock xbacklight feh conky conky-manager pasystray paman paprefs pavumeter pulseaudio-module-zeroconf pavucontrol variety numlockx lxappearance xsel terminator -y

#simlink i3 config into place.
mkdir -p $HOME/.config
ln -s $PWD/.config/i3 $HOME/.config/i3

#simlink conky library into place
ln -s $PWD/.conky $HOME/.conky

#simlink screenshot script into place
sudo ln -s $PWD/screenshot.sh /usr/local/bin/screenshot
