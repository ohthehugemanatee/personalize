#!/bin/bash

# Installs applications and tools I like, want, and need.

if [ -d /etc/apt/sources.list.d ]; then
  sudo cp sources.list.d/* /etc/apt/sources.list.d
fi

sudo apt install -y php php-ext-dom phpunit php-mbstring php-easyrdf openssh-server composer bundler ruby-dev cpupower cpufrequtils powertop gcc build-essential

sudo apt install -y dropbox slack

# Use Overlay FS for docker
sudo ln -s $PWD/etc/docker/daemon.json /etc/docker/daemon.json
