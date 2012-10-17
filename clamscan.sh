#!/bin/bash

# A simple BASH script to make some sensible decisions on virus scans

MAIL_TO=root@localhost
MAIL_ON_CLEAN=0
MAIL_ON_VIRUS=1
MAIL_ON_ERROR=1
LOGFILE=/var/log/clamscan/clamscan-`date +"%d%b%y"`.log
SCAN_DIRECTORIES="/bin /boot /etc /home /lib* /mnt /opt /root /sbin /srv /usr /var"
DETECT_STRUCTURES=0

freshclam

if [ $DETECT_STRUCTURES -eq 1 ]; then
	clamscan -ril $LOGFILE --detect-structured=yes $SCAN_DIRECTORIES
else
	clamscan -ril $LOGFILE $SCAN_DIRECTORIES
fi
exitcode=$?

if [ $exitcode -eq 0 ]; then
	# Clean
	if [ $MAIL_ON_CLEAN -eq 1 ]; then
		cat $LOGFILE | mail -s "`hostname` automated virus scan: CLEAN" $MAIL_TO
	fi
elif [ $exitcode -eq 1 ]; then
	# Viruses
	if [ $MAIL_ON_VIRUS -eq 1 ]; then
		cat $LOGFILE | mail -s "`hostname` automated virus scan: INFECTED" $MAIL_TO
	fi
else
	# Errors
	if [ $MAIL_ON_ERROR -eq 1 ]; then
		cat $LOGFILE | mail -s "`hostname` automated virus scan: ERROR" $MAIL_TO
	fi
fi
