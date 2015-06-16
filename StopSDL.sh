#!/bin/bash
read pid < sdl.pid
kill -TERM $pid
rm sdl.pid
sleep 1
exit 0
