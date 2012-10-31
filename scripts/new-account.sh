#!/bin/bash
cd ~
ln -s personalize/.ssh
chmod -R go-rwx .ssh/*
ln -s personalize/.bashrc
ln -s personalize/.bash_profile
ln -s personalize/.gitconfig
ln -s personalize/.vim
ln -s personalize/.vimrc
