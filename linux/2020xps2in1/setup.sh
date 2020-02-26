#!/bin/bash

# Setup the system _just right_. Updated for Mandriva


# Globals.
INSTALLER="pamac -y"
PERSONALIZE=$HOME/personalize
SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir $HOME/tmp

# Install:
# * vscode?
# Assume manually installed: 
# * i3
# * skype

# Link i3 config
ln -sf $SOURCE/.i3 $HOME/.i3
ln -sf $SOURCE/.config/i3status $HOME/.config/i3status

# Sudoers access for mounting veracrypt
sudo cp $SOURCE/etc/sudoers.d/veracrypt /etc/sudoers.d

# ZSH and oh-my-zsh
$INSTALLER zsh
# Run this manually because it interrupts the script.
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Fancy powerline fonts for the terminal
cd /tmp; git clone https://github.com/powerline/fonts.git; cd fonts; ./install.sh

#copy fonts into place.
cp $PERSONALIZE/.fonts/* $HOME/.fonts

# Pretty ping.
sudo ln -sf $SOURCE/usr/local/bin/prettyping /usr/local/bin/prettyping
# Diff-so-fancy
sudo ln -sf $SOURCE/usr/local/bin/diff-so-fancy /usr/local/bin/diff-so-fancy

# Screen xrandr scripts
ln -sf $SOURCE/.screenlayout $HOME

# simlink my scripts.
sudo ln -sf $SOURCE/usr/local/bin/screenshot.sh /usr/local/bin/screenshot
sudo ln -sf $SOURCE/usr/local/bin/configure-screens.sh /usr/local/bin/configure-screens.sh

# mutt et al
$INSTALLER mutt w3m w3m-img urlscan msmtp goobook-git notmuch
mkdir $HOME/log
goobook authenticate
# personal bin dir.
sudo ln -sf $SOURCE/bin $HOME/bin

# Xmodmap for euro key. Note otherwise I should be on dell US keyboard layout, with options lv3:switch, compose:ralt, terminate:ctrl_alt_bksp.
ln -sf $SOURCE/Xmodmap $HOME/.Xmodmap

# Thefuck shell script.
$INSTALLER thefuck

# Various
# * Docker/-compose
# * audacious
# * timeshift system backup utility
# * signal desktop app
# * Steam
# * kubectl
# * net-tools (ifconfig etc)
# * pulse audio
# * simplenote
# * xidlehook
$INSTALLER docker-compose audacious timeshift signal-desktop steam kubectl net-tools manjaro-pulse pulseaudio-alsa simplenote-electron-bin xidlehook

# Snap installs:
# * PHPStorm IDE.
sudo snap install phpstorm --classic

# TLDR manpages
curl -o /tmp/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
sudo mv /tmp/tldr /usr/local/bin
sudo chmod +x /usr/local/bin/tldr

# Simlink .profile and .Xresources
ln -sf $PERSONALIZE/linux/2020xps2in1/.profile ~
ln -sf $PERSONALIZE/linux/2020xps2in1/.Xresources ~

# Config for morc_menu
ln -sf $PERSONALIZE/linux/2020xps2in1/morc_menu_v1.conf $HOME/.config/morc_menu

# screen rotation - specific to this model. Make code changes for future devices...
cd ~/tmp
git clone git@github.com:ohthehugemanatee/2in1screen.git
cd 2in1screen
make
cp -f 2in1screen $HOME/bin

# Setup suspend on lid close
sudo cp $PERSONALIZE/linux/2020xps2in1/etc/systemd/system/suspend@.service /etc/systemd/system/
systemctl enable suspend@${USER}

# Manual installs
echo "These applications must be manually installed from their websites. How crappy.

* Firefox Nightly
* PrivateInternetAccess
* Spotify
* Whatsie
* Viber

Other manual steps:

* Killer wireless has problematic firmware. Use an upstream one from github. Take /lib/firmware/ath10k/QCA6174/hw3.0/ board.bin, board-2.bin, and firmware-6.bin from https://github.com/kvalo/ath10k-firmware/

If I'm smart, I've kept my /opt directory so you can just symlink (by hand)."
