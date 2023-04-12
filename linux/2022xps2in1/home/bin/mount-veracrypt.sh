#!/bin/bash

# Mount my veracrypt drive, using secrets from the keychain.

/usr/bin/veracrypt -t --non-interactive --password=$(secret-tool lookup title veracrypt1) --use-dummy-sudo-password  -m=nokernelcrypto --mount /home/ohthehugemanatee/Nextcloud/Campbells\ homedir/encrypted.tc /mnt/veracrypt1 

