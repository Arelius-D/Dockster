#!/bin/bash
LOGFILE="/srv/logs/index.html"
ERRORFILE="/srv/logs/error.log"

echo "Starting update script" >> $LOGFILE
apt-get update >> $LOGFILE 2>> $ERRORFILE
apt-get full-upgrade -y >> $LOGFILE 2>> $ERRORFILE
apt-get autoremove --purge -y >> $LOGFILE 2>> $ERRORFILE
apt-get clean >> $LOGFILE 2>> $ERRORFILE
echo "Update script completed" >> $LOGFILE
