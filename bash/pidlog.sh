#!/bin/bash

CPULOG=/var/log/pidlogs/cpu.log
MEMLOG=/var/log/pidlogs/mem.log

# Get CPU data in a log
date >> $CPULOG
ps aux | head -1 >> $CPULOG
ps aux | sort -rnk3 | head -10 >> $CPULOG
echo >> $CPULOG


# Get RAM data in a log
date >> $MEMLOG
ps aux | head -1 >> $MEMLOG
ps aux | sort -rnk4 | head -10 >> $MEMLOG
echo >> $MEMLOG
