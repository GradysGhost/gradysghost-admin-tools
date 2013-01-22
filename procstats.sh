#!/bin/bash

PROCESS_NAME=httpd

TOTAL=0;
COUNT=0;
for VAL in `ps aux | grep $PROCESS_NAME | awk '{print $4}'`
do
	TOTAL=$(echo "$TOTAL + $VAL" | bc)
	COUNT=$(($COUNT + 1))
done
MEAN=$(echo "$TOTAL / $COUNT" | bc)
echo "Total memory consumption: $TOTAL%"
echo "Average memory consumption per process: $MEAN%"
