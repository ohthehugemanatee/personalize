#!/bin/bash

# Simple script to start/stop my Azure remote workstation.
# Requires:
# - Azure CLI configured
# - Remmina RDP client
# 

# Change these values to match your VM.
GROUP=WORKSTATION
MACHINE=win10work2
RDPCONFIG=~/.remmina/1518788004229.remmina

REMMINA=$(which remmina)
AZ=$(which az)
ZENITY=$(which zenity)

case "$1" in
  start)
    echo "Starting Azure workstation and connecting via RDP."
    ${AZ} vm start -g $GROUP -n $MACHINE |\
    $ZENITY --progress --auto-kill --auto-close --pulsate --text="Starting Azure workstation" && \
    ${REMMINA} -c $RDPCONFIG
    ;;
  stop)
    echo "Shutting down Azure workstation and killing Remmina..."
    ${AZ} vm deallocate -g $GROUP -n $MACHINE |\
    $ZENITY --progress --auto-kill --auto-close --pulsate --text="Shutting down Azure workstation" && \
    ${REMMINA} -q
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}" >&2
    exit 1
    ;;
esac

