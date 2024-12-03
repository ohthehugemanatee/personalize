#!/bin/bash

# Script to enable/disable keyboard capability on the Remarkable 2.

# Check if the script is being run with root privileges.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Function to display usage information.
usage() {
  echo "Usage: $0 {enable|disable}"
  exit 2
}

# Check command line arguments.
if [ "$#" -ne 1 ]; then
    usage
fi

ROLE_FILE="/sys/kernel/debug/ci_hdrc.0/role"

# Check if the role file exists.
if [ ! -f "$ROLE_FILE" ]; then
    echo "The role file $ROLE_FILE does not exist. Ensure your system has the ci_hdrc module enabled."
    exit 3
fi

# Toggle the USB role based on the argument.
case "$1" in
    enable)
        echo "host" > "$ROLE_FILE"
        echo "USB role set to host."
        ;;
    disable)
        echo "gadget" > "$ROLE_FILE"
        echo "USB role set to gadget."
        ;;
    *)
        usage
        ;;
esac

