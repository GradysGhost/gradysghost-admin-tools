#!/bin/bash

PROCESS_NAME=httpd

TOTAL=0;
COUNT=0;
for PID in `ps aux | grep $PROCESS_NAME | grep -v grep | awk '{print $2}'`
do
	VAL=`pmap -d $PID | grep writeable/private | awk '{print $4}' | sed 's/K//'`
    TOTAL=$(echo "$TOTAL + $VAL" | bc)
    COUNT=$(($COUNT + 1))
done
MEAN=$(echo "$TOTAL / $COUNT" | bc)
TOTAL_MB=$(echo "$TOTAL / 1024" | bc)
MEAN_MB=$(echo "$MEAN / 1024" | bc)
echo "Process name: $PROCESS_NAME"
echo "Total processes: $COUNT"
echo "Total memory consumption: $TOTAL bytes"
echo "        $TOTAL_MB MB"
echo "Average memory consumption per process: $MEAN bytes"
echo "        $MEAN_MB MB"

