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
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - # google talk/hangouts
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - # docker
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E # dropbox
sudo add-apt-repository ppa:numix/ppa # themes.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo add-apt-repository "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main" 
sudo add-apt-repository multiverse # various. Notably Steam.
sudo add-apt-repository ppa:ondrej/php # php modules
sudo add-apt-repository ppa:nilarimogard/webupd8 # audacious music player

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
# * j4-dmenu-desktop, dMenu for .desktop files
# 
# A lot of the desktop setup comes from https://github.com/erikdubois/i3-on-Linux-Mint-18-Cinnamon.git and the corresponding blog post.

sudo apt install i3 i3lock suckless-tools i3status dmenu i3lock xbacklight feh conky pasystray paman paprefs pavumeter pulseaudio-module-zeroconf pavucontrol variety numlockx lxappearance xsel terminator j4-dmenu-desktop -y

#simlink i3 config into place.
mkdir -p $HOME/.config
ln -sf $PERSONAlIZE/.config/i3 $HOME/.config/i3

#simlink conky library into place
ln -sf $PERSONAlIZE/.conky $HOME/.conky

#simlink screenshot script into place
sudo ln -sf $PERSONAlIZE/screenshot.sh /usr/local/bin/screenshot

# Install applications and tools I like, want, and need.
sudo apt install -y php phpunit php-mbstring php-sqlite3 openssh-server composer bundler ruby-dev powertop gcc build-essential dropbox steam

# Use Overlay FS for docker
sudo ln -sf $PERSONAlIZE/etc/docker/daemon.json /etc/docker/daemon.json

# Toggl desktop client
cd /tmp
wget http://fr.archive.ubuntu.com/ubuntu/pool/main/g/gst-plugins-base0.10/libgstreamer-plugins-base0.10-0_0.10.36-1_amd64.deb # no longer available in Ubuntu > 16.04
wget http://fr.archive.ubuntu.com/ubuntu/pool/universe/g/gstreamer0.10/libgstreamer0.10-0_0.10.36-1.5ubuntu1_amd64.deb # no longer available in Ubuntu > 16.04
sudo dpkg -i libgstreamer*.deb
wget https://toggl.com/api/v8/installer?app=td&platform=deb64&channel=stable
sudo dpkg -i toggldesktop_*.deb
# If font sizes are fucked on hiDPI, you have to download/install Qt manually, and remove the Qt libs bundled with Toggl.
cd /tmp
wget http://download.qt.io/official_releases/qt/5.9/5.9.0/qt-opensource-linux-x64-5.9.0.run
sh ./qt-opensource-linux-x64-5.9.0.run
sudo rm -rf /opt/toggldesktop/lib/libQt*
# the oh-my-zsh misc.zsh startup script sets env variable QT_AUTO_SCREEN_SCALE_FACTOR=1 which is what really makes the scaling magic happen.

# Zoom meetings
cd /tmp
sudo apt install libxcb-xtest0 libxcb-xtest0-dev -y
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo dpkg -i zoom_amd64.deb

# Simplenote
cd /tmp
wget https://github.com/Automattic/simplenote-electron/releases/download/v1.0.8/simplenote-1.0.8.deb
sudo dpkg -i simplenote-1.0.8.deb

# Skype for Linux
cd /tmp
wget https://go.skype.com/skypeforlinux-64.deb
sudo dpkg -i skypeforlinux-64.deb

# mouse, synaptics configuration.
sudo mkdir -p /etc/X11/xorg.conf.d
sudo ln -sf $PERSONALIZE/60-trackpad.conf /etc/X11/xorg.conf.d/

# set default editor to vim (option 3)
sudo update-alternatives --config editor <<< '3'

# Manual installs
echo "These applications must be manually installed from their websites. How crappy.

* Firefox developer edition
* PrivateInternetAccess
* Spotify
* PHPStorm
* Franz
* Whatsie
* Viber
* Zoom

If I'm smart, I've kept my /opt directory so you can just symlink (by hand)."
