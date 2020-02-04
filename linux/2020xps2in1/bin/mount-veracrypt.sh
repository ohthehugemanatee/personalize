#!/bin/bash

# Mount my veracrypt drive, using secrets from the keychain.

sudo veracrypt --password=$(secret-tool lookup title veracrypt1) --mount $PWD/Nextcloud/Campbells\ homedir/encrypted.tc /mnt/veracrypt1
