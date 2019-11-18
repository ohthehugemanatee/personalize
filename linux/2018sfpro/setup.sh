#!/bin/bash
set -e

# Setup the system _just right_.


# Globals.
PERSONALIZE=$HOME/personalize
#mkdir $HOME/tmp

# Add my apt sources.
if [ -d /etc/apt/sources.list.d ]; then
  sudo add-apt-repository ppa:teejee2008/ppa
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EF4186FE247510BE
  sudo ln -sf sources.list.d/* /etc/apt/sources.list.d/
fi
# Add some manual keys and repos.
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - # google talk/hangouts
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - # docker
sudo add-apt-repository ppa:numix/ppa # themes.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo add-apt-repository multiverse # various. Notably Steam.
sudo add-apt-repository ppa:ondrej/php # php modules
sudo add-apt-repository ppa:nilarimogard/webupd8 # audacious music player
sudo apt-add-repository -y ppa:teejee2008/ppa # timeshift system backup utility

# Install applications and tools I like, want, and need.
sudo apt install -y php phpunit php-mbstring php-sqlite3 openssh-server bundler ruby-dev powertop gcc build-essential steam timeshift

# # Install nodeJS LTS
# sudo apt-get install curl software-properties-common -y
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash
sudo apt install nodejs -y

# Install composer to scripts directory.
installComposer
# Pretty ping.
sudo ln -sf $HOME/personalize/linux/2017xps13/usr/local/bin/prettyping /usr/local/bin/prettyping
# Diff-so-fancy
sudo ln -sf $HOME/personalize/linux/2017xps13/usr/local/bin/diff-so-fancy /usr/local/bin/diff-so-fancy
# HTTPie
sudo apt install httpie -y 

# Use Overlay FS for docker
sudo ln -sf $PERSONALIZE/etc/docker/daemon.json /etc/docker/daemon.json

# timeshift configuration and cronjob.
# sudo ln -sf $PERSONALIZE/linux/2017xps13/etc/timeshift.json /etc/timeshift.json
# sudo ln -s $PERSONALIZE/linux/2017xps13/etc/cron.d/timeshift-hourly /etc/cron.d/timeshift-hourly

# Screen xrandr scripts
ln -sf $PERSONALIZE/.screenlayout $HOME

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
sudo ln -sf $PERSONAlIZE/usr/local/bin/screenshot.sh /usr/local/bin/screenshot
sudo ln -sf $PERSONALIZE/usr/local/bin/winvm.sh /usr/local/bin/winvm
sudo ln -sf $PERSONALIZE/usr/local/bin/configure-screens.sh /usr/local/bin/configure-screens.sh
sudo ln -sf $PERSONALIZE/usr/local/bin/toggle-fn.sh /usr/local/bin/toggle-fn.sh
sudo ln -s $PWD/linux/2017xps13/usr/local/bin/dunst_push_notify.sh /usr/local/bin/dunst_push_notify.sh

# mutt et al
sudo apt install mutt w3m w3m-img urlscan msmtp goobook notmuch -y
sudo ln -sf $PERSONALIZE/usr/local/bin/msmtp-offline /usr/local/bin/
sudo ln -sf $PERSONALIZE/usr/local/bin/msmtp-queue /usr/local/bin/
sudo ln -sf $PERSONALIZE/usr/local/bin/text2mime-markdown.pl /usr/local/bin/
sudo ln -sf $PERSONALIZE/usr/local/bin/text2mime-sendmail.pl /usr/local/bin/
mkdir $HOME/log
# don't forget to run `goobook authenticate`!

# Add udev rule for toggling Fn when plugging in an Apple keyboard.
sudo ln -sf $PERSONALIZE/etc/udev/rules.d/85-external-mac-keyboard.rules /etc/udev/rules.d/85-external-mac-keyboard.rules
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

# Thefuck shell script.
sudo apt install python3-dev python3-pip -y
pip3 install thefuck

# PHPStorm IDE.
sudo snap install phpstorm --classic

# TLDR manpages
npm install -g tldr

# Dell fan control 
#Dell's BIOS wants to take control of the fans, and it never uses them until it's already throttled the CPU. I have to compile a program to flip a bit in the CMOS (https://github.com/TomFreudenberg/dell-bios-fan-control.git). Use the linked systemctl script which enables/disables bios fan control with the i8kmon service. You can validate it's working by turning all the fans on max with `i8kfan 2 2`.
#@See https://github.com/vitorafsr/i8kutils/issues/6#issuecomment-318267697
#@See https://daenney.github.io/2017/11/11/arch-linux-xps-13-9360
sudo ln -sf $PERSONALIZE/usr/local/bin/dell-bios-fan-control /usr/local/bin
sudo apt install -y i8kutils 
sudo ln -sf $PERSONALIZE/etc/systemd/system/multi-user.target.wants/i8kmon.service /etc/systemd/system/multi-user.target.wants

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

  // Install composer.
  function installComposer () {

    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
    then
      >&2 echo 'ERROR: Invalid installer signature'
      rm composer-setup.php
      exit 1
    fi

    php composer-setup.php --quiet
    RESULT=$?
    rm composer-setup.php
    return $RESULT
  }
