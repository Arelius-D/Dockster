#!/bin/bash
# Log paths
LOGFILE="/srv/logs/update.log"
ERRORFILE="/srv/logs/error.log"

# Ensure log directory exists
mkdir -p /srv/logs
touch $LOGFILE $ERRORFILE

# Start logging
echo "Starting update script at $(date)" >> $LOGFILE
{
    apt-get update
    apt-get full-upgrade -y
    apt-get autoremove --purge -y
    apt-get clean
    echo "Update script completed at $(date)"
} >> $LOGFILE 2>> $ERRORFILE
