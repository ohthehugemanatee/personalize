#!/bin/bash
# Script name: delayed-hibernation.sh
# Purpose: Auto hibernates after a period of sleep
# Edit the `TIMEOUT` variable in the `$hibernation_conf` file to set the number of seconds to sleep.

hibernation_lock='/var/run/delayed-hibernation.lock'
hibernation_fail='/var/run/delayed-hibernation.fail'
hibernation_conf='/etc/delayed-hibernation.conf'

# Checking the configuration file
if [ ! -f $hibernation_conf ]; then
    echo "Missing configuration file ('$hibernation_conf'), aborting."
    exit 1
fi
hibernation_timeout=$(grep "^[^#]" $hibernation_conf | grep "TIMEOUT=" | awk -F'=' '{ print $2 }' | awk -F'#' '{print $1}' | tr -d '[[ \t]]')
if [ "$hibernation_timeout" = "" ]; then
    echo "Missing 'TIMEOUT' parameter from configuration file ('$hibernation_conf'), aborting."
    exit 1
elif [[ ! "$hibernation_timeout" =~ ^[0-9]+$ ]]; then
    echo "Bad 'TIMEOUT' parameter ('$hibernation_timeout') in configuration file ('$hibernation_conf'), expected number of seconds, aborting."
    exit 1
fi

# Processing given parameters
if [ "$2" = "suspend" ]; then
    curtime=$(date +%s)
    if [ "$1" = "pre" ]; then
        if [ -f $hibernation_fail ]; then
            echo "Failed hibernation detected, skipping setting RTC wakeup timer."
        else
            echo "Suspend detected. Recording time, set RTC timer"
            echo "$curtime" > $hibernation_lock
            rtcwake -m no -s $hibernation_timeout
        fi
    elif [ "$1" = "post" ]; then
        if [ -f $hibernation_fail ]; then
            rm $hibernation_fail
        fi
        if [ -f $hibernation_lock ]; then
            sustime=$(cat $hibernation_lock)
            rm $hibernation_lock
            if [ $(($curtime - $sustime)) -ge $hibernation_timeout ]; then
                echo "Automatic resume from suspend detected. Hibernating..."
                systemctl hibernate
                if [ $? -ne 0 ]; then
                    echo "Automatic hibernation failed. Trying to suspend instead."
                    touch $hibernation_fail
                    systemctl suspend
                    if [ $? -ne 0 ]; then
                        echo "Automatic hibernation and suspend failover failed. Nothing else to try."
                    fi
                fi
            else
                echo "Manual resume from suspend detected. Clearing RTC timer"
                rtcwake -m disable
            fi
        else
            echo "File '$hibernation_lock' was not found, nothing to do"
        fi
    else
        echo "Unrecognised first parameter: '$1', expected 'pre' or 'post'"
    fi
else
    echo "This script is intended to be run by systemctl delayed-hibernation.service (expected second parameter: 'suspend')"
fi
