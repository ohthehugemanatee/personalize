#!/bin/bash

# Installs all packages listed in pkglist.
sudo pacman -S - < pkglist.txt

# Installs only the common packages (i.e. excludes AUR)
# sudo pacman -S $(comm -12 <(pacman -Slq | sort) <(sort pkglist.txt))
