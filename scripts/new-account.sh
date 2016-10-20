#!/bin/bash
cd ~
ln -s personalize/.ssh
chmod -R go-rwx .ssh/*
ln -s personalize/.bashrc
ln -s personalize/.bash_profile
ln -s personalize/.gitconfig
ln -s personalize/.vim
ln -s personalize/.vimrc
ln -s personalize/.drush
mkdir .vagrant.d
ln -s personalize/Vagrantfile .vagrant.d/Vagrantfile
ln -s personalize/.selected-editor
