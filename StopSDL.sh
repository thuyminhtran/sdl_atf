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

function is_telnet_socket_closed {
    #TODO(AKutsan) APPLINK-15273 Remove waiting for closing telnet port
    res=$(netstat -pna 2>/dev/null | grep 6676 | wc -l);
    [ $res -gt 1 ] && return 1 || return 0;
}

shutdown_sdl || kill_sdl
rm sdl.pid
