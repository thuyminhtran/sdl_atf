#!/bin/bash
echo "Stop SDL"
shutdown_time=10
read pid < sdl.pid
kill -SIGINT $pid
rm sdl.pid
for x in `seq $shutdown_time`
do
    sleep 1
    test -e  /proc/$pid || exit 0
done
echo "Unable to stop SDL correctly during "$shutdown_time" seconds"
echo "Kill SDL process : "$pid
kill -SIGTERM $pid
exit 1
