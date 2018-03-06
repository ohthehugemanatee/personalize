#!/bin/bash

# Simple script to start/stop my Azure remote workstation.

REMMINA=$(which remmina)
AZ=$(which az)

case "$1" in
  start)
    echo "Starting Azure workstation..."
    ${AZ} vm start -g WORKSTATION -n win10work2
    echo "Connecting via RDP..."
    ${REMMINA} -c ~/.remmina/1518788004229.remmina
    ;;
  stop)
    echo "Shutting down Azure workstation..."
    ${AZ} vm stop -g WORKSTATION -n win10work2
    echo "Shutting down Remmina..."
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

