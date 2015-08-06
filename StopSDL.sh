#!/bin/bash
shutdown_time=10
read pid < sdl.pid

function shutdown_sdl {
    kill -SIGINT $pid
    for x in `seq $shutdown_time`
    do
        sleep 1
        test -e  /proc/$pid || return 0;
    done
    echo "Unable to stop SDL correctly during "$shutdown_time" seconds"
    return 1
}

function kill_sdl {
    echo "Kill SDL process : "$pid
    kill -SIGTERM $pid
}

shutdown_sdl || kill_sdl
rm sdl.pid
