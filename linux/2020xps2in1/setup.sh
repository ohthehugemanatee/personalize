#!/bin/bash

# Setup the system _just right_. Updated for Mandriva


# Globals.
INSTALLER="pamac -y"
PERSONALIZE=$HOME/personalize
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE_DIR[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir $HOME/tmp

source link_subdirs.sh

# Variety wallpaper manager
$INSTALLER variety python-pywal
mv $HOME/.config/variety/scripts/set_wallpaper $HOME/.config/variety/scripts/set_wallpaper.bak
# modified version of this script.
ln -sf $SOURCE_DIR/variety/scripts/set_wallpaper $HOME/.config/variety/scripts/set_wallpaper 

# Sudoers access for mounting veracrypt
sudo cp $SOURCE_DIR/etc/sudoers.d/veracrypt /etc/sudoers.d

# ZSH and oh-my-zsh
$INSTALLER zsh
echo "Run this manually because it interrupts the script:"
echo 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

# Fancy powerline fonts for the terminal
cd /tmp; git clone https://github.com/powerline/fonts.git; cd fonts; ./install.sh

# mutt et al
$INSTALLER mutt w3m w3m-img urlscan msmtp goobook-git notmuch
mkdir $HOME/log
goobook authenticate

# Various installs
$INSTALLER install docker-compose audacious timeshift signal-desktop steam kubectl net-tools manjaro-pulse pulseaudio-alsa simplenote-electron-bin pamac-tray-appindicator wl-clipboard pcmanfm-qt swaynag-battery wofi firefox-nightly pia-manager spotify whatsapp-nativifier alacritty thefuck viber

# remove legacy X pcmanfm, morc_menu
$INSTALLER remove pcmanfm morc_menu

# TLDR manpages
curl -o /tmp/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
sudo mv /tmp/tldr /usr/local/bin
sudo chmod +x /usr/local/bin/tldr

# Setup suspend on lid close
sudo cp $SOURCE_DIR/etc/systemd/system/suspend@.service /etc/systemd/system/

