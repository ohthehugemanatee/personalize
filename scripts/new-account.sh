#!/bin/bash
cd ~
ln -s personalize/.ssh
chmod -R go-rwx .ssh/*
ln -s personalize/.bash_profile
ln -s personalize/.zshrc
ln -s personalize/.gitconfig
ln -s personalize/.vim
ln -s personalize/.vimrc
ln -s personalize/.drush
mkdir .vagrant.d
ln -s personalize/Vagrantfile .vagrant.d/Vagrantfile
ln -s personalize/.selected-editor
cd ~/.oh-my-zsh/custom && ln -sf personalize/zsh/custom/*
ln -s personalize/.tmux.conf
