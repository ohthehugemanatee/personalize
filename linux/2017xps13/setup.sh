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
# * j4-dmenu-desktop, dMenu for .desktop files
# * rofi, alternative dmenu replacement.
# * polybar, a more awesome i3-bar
# 
# A lot of the desktop setup comes from https://github.com/erikdubois/i3-on-Linux-Mint-18-Cinnamon.git and the corresponding blog post.

sudo apt install i3lock suckless-tools i3status dmenu i3lock xbacklight feh conky pasystray paman paprefs pavumeter pulseaudio-module-zeroconf pavucontrol variety numlockx lxappearance xsel j4-dmenu-desktop -y

# replace i3 with i3-gaps
sudo apt install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev dh-autoreconf -y 
cd /tmp; git clone --recursive https://github.com/Airblader/xcb-util-xrm.git; cd xcb-util-xrm
./autogen; make; sudo ldconfig
cd /tmp; git clone https://www.github.com/Airblader/i3 i3-gaps; cd i3-gaps
autoreconf --force --install
rm -Rf build/; mkdir build; cd build/; ../configure --prefix=/usr --sysconfdir=/etc; make; make -j8
sudo make install
#simlink i3 config into place.
mkdir -p $HOME/.config
ln -sf $PERSONAlIZE/.config/i3 $HOME/.config/i3
#simlink rofi config into place
ln -sf $PERSONALIZE/.config/rofi $HOME/.config/rofi
#simlink polybar config into place. NB: This will probably need extra fonts that I missed. :|
ln -sf $PERSONALIZE/.config/polybar $HOME/.config/polybar
#simlink conky library into place
ln -sf $PERSONAlIZE/.conky $HOME/.conky
#simlink Xresources into place.
ln -sf $PERSONALIZE/.Xresources ~/.Xresources
#Add fancy powerline fonts for the terminal
cd /tmp; git clone git@github.com:powerline/fonts.git; cd fonts; ./install.screenshot

#copy fonts into place.
cp $PERSONALIZE/.fonts/* $HOME/.fonts

#simlink screenshot script into place
sudo ln -sf $PERSONAlIZE/screenshot.sh /usr/local/bin/screenshot

# Install applications and tools I like, want, and need.
sudo apt install -y php phpunit php-mbstring php-sqlite3 openssh-server bundler ruby-dev powertop gcc build-essential dropbox steam

# Install composer to scripts directory.
if [ ! -f $HOME/scripts/composer.phar ]; then
  cd $HOME/scripts
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
fi
sudo ln -sf $HOME/scripts/composer.phar /usr/local/bin/

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
sudo ln -sf $PERSONALIZE/etc/X11/xorg.conf.d/60-trackpad.conf /etc/X11/xorg.conf.d/

# set default editor to vim (option 3)
sudo update-alternatives --config editor <<< '3'

# simlink my scripts.
sudo ln -sf $PERSONALIZE/usr/local/bin/screenshot.sh /usr/local/bin/screenshot
sudo ln -sf $PERSONALIZE/usr/local/bin/configure-screens.sh /usr/local/bin/configure-screens.sh
sudo ln -sf $PERSONALIZE/usr/local/bin/battery-nag.sh /usr/local/bin/battery-nag.sh
# add battery-nag to the crontab.
(crontab -l ; echo "*/1 * * * * /usr/local/bin/battery-nag.sh") | crontab -

# Screen config for lightdm
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo ln -sf $PERSONALIZE/etc/lightdm/lightdm.conf.d/60-configure-screens.conf /etc/lightdm/lightdm.conf.d/

# Install Ukuu for kernel updates
sudo apt install ukuu -y

# Xmodmap for euro key. Note otherwise I should be on dell US keyboard layout, with options lv3:switch, compose:ralt, terminate:ctrl_alt_bksp.
ln -sf $PERSONALIZE/Xmodmap $HOME/.Xmodmap

# Pass password manager.
sudo apt install qtpass -y
sudo ln -sf /usr/share/doc/pass/passmenu /usr/local/bin/

# Thefuck shell script.
sudo apt install python3-dev python3-pip -y
pip3 install thefuck

# Manual installs
echo "These applications must be manually installed from their websites. How crappy.

* Firefox Nightly
* Browserpass extension
* PrivateInternetAccess
* Spotify
* PHPStorm
* Franz
* Whatsie
* Viber
* Zoom

If I'm smart, I've kept my /opt directory so you can just symlink (by hand)."
