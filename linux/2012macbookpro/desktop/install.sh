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

# setup i3-cinnamon for i3 with cinnamon/gnome session management
git clone https://github.com/Gigadoc2/i3-cinnamon.git
cd i3-cinnamon/
sudo install -D -m 644 i3-cinnamon-xsession.desktop /usr/share/xsessions/i3-cinnamon-xsession.desktop
sudo install -D -m 644 i3-cinnamon.session /usr/share/cinnamon-session/sessions/i3-cinnamon.session
sudo install -D -m 644 i3-cinnamon-app.desktop /usr/share/applications/i3-cinnamon.desktop
sudo install -D -m 755 i3-cinnamon /usr/bin/i3-cinnamon
sudo install -D -m 755 cinnamon-session-i3 /usr/bin/cinnamon-session-i3
sudo update-desktop-database -q
