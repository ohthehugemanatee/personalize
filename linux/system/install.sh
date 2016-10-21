#!/bin/bash

# Installs applications and tools I like, want, and need.

if [ -d /etc/apt/sources.list.d ]; then
  sudo cp sources.list.d/* /etc/apt/sources.list.d
fi

sudo apt install -y php php-ext-dom phpunit php-mbstring php-easyrdf openssh-server composer bundler ruby-dev cpupower cpufrequtils powertop gcc build-essential

sudo apt install -y dropbox slack

sudo ln -s $PWD/wifi-on-resume.sh /etc/pm/sleep.d/wifi-on-resume
