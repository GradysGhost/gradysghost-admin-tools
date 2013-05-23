PID=$1

echo 0 $(cat /proc/$PID/smaps | grep 'Rss' | awk '{print $2}' | sed 's#^#+#') | bc
