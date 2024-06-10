#!/bin/bash

# Mount my veracrypt drive, using secrets from the keychain.

# Requirements:
# - Download/Install veracrypt from https://www.veracrypt.fr/en/Downloads.html
# - apt install libsecret-tools 
# - store the block device password with `secret-tool store --label='veracrypt1' title veracrypt1` (it asks for password interactively)
# - sudo mkdir /mnt/veracrypt1
#

/usr/bin/veracrypt -t --non-interactive --password=$(secret-tool lookup title veracrypt1) --use-dummy-sudo-password  -m=nokernelcrypto --mount /home/ohthehugemanatee/Nextcloud/Campbells\ homedir/encrypted.tc /mnt/veracrypt1 

