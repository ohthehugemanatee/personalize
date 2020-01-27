#!/bin/bash

# Setup the system _just right_. Updated for Mandriva


# Globals.
PERSONALIZE=$HOME/personalize
SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir $HOME/tmp

# Install:
# * docker
# * vscode?
# * audacious music player
# * timeshift system backup utility
# * Signal messenger
# * Powerline fonts
# * Steam
# * powertop
# * Simplenote
# * Skype for linux
#
# Assume manually installed: 
# * i3

# ZSH and oh-my-zsh
sudo pacman -S zsh
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
sudo pacman -S mutt w3m w3m-img urlscan msmtp goobook notmuch
sudo ln -sf $SOURCE/usr/local/bin/msmtp-offline /usr/local/bin/
sudo ln -sf $SOURCE/usr/local/bin/msmtp-queue /usr/local/bin/
sudo ln -sf $SOURCE/usr/local/bin/text2mime-markdown.pl /usr/local/bin/
sudo ln -sf $SOURCE/usr/local/bin/text2mime-sendmail.pl /usr/local/bin/
mkdir $HOME/log
goobook authenticate


# Xmodmap for euro key. Note otherwise I should be on dell US keyboard layout, with options lv3:switch, compose:ralt, terminate:ctrl_alt_bksp.
ln -sf $SOURCE/Xmodmap $HOME/.Xmodmap

# Thefuck shell script.
sudo pacman -S thefuck

# PHPStorm IDE.
sudo snap install phpstorm --classic

# TLDR manpages
curl -o /tmp/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
sudo mv /tmp/tldr /usr/local/bin
sudo chmod +x /usr/local/bin/tldr

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
