#!/bin/bash

# Send notifications from Dunst to the notify push service.
# This script is called from dunst with the following arguments:
# appname summary body icon urgency

APPNAME=$1
BODY=$3

/home/ohthehugemanatee/.nvm/versions/node/v6.7.0/bin/notify -i $APPNAME -t $BODY
