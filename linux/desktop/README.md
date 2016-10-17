My linux configs
===

Folders:
* Desktop: Anything for configuring the desktop environment
* System: Configs for daemons and services
* Machines: Configs for particular hardware, with subdirs by machine


Desktop
---

Currently i3. Installing the specific packages is handled by install.sh. It also simlinks the .config/i3 directory into place. Components:

* I3 tiling window manager
  * i3 lock screen provider
  * i3 status bar provider
  * i3's dmenu menu provider
  * compton, i3 compatible compositor
* xbacklight, for controlling screen backlight
* feh, command line image viewer
* conky, conky-manager for lightweight status widgets
* pulseaudio and pa\* tools: audio interface and corresponding taskbar item
* variety, wallpaper downloader/switcher
* numlockx, numlock controller
* lxappearance, GTK+ theme switcher
* scrot, screenshot utility
* unclutter, hides the cursor when typing
* terminator, alternative terminal emulator

A lot of the desktop setup comes from https://github.com/erikdubois/i3-on-Linux-Mint-18-Cinnamon.git and the corresponding blog post. 

I don't know how complete this is, but it's a start.

System
---

Just an install.sh with all the common tools I need: 
* php and extensions for Drupal
* phpunit
* openssh-server
* composer
* ruby bundler and dev
* htop, powertop
* gcc build tools
* slack

There are lots of other tools which require browsing to their website and downloading from there. Pain in the ass, but there it is.

* Firefox developer edition
* Toggl
* PrivateInternetAccess
* Spotify

We try just copying our sources.list.d entries into place... but by the time I actually use this script, they might be out of date. YMMV.
o

Machines
---

Starting with just the macbook pro 9,2, which needs:
* synaptics customizations
* xbacklight
* custom script for keyboard backlight control
* custom script for "say" 

And of course an install.sh to copy it all into place.
