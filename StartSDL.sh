#!/bin/bash

dirSDL=$1
dirATF=$(pwd)
appName=$2
cd $dirSDL
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:. export LD_LIBRARY_PATH
xterm -e ./$appName &
cd $dirATF 
touch sdl.pid
echo $! > sdl.pid
sleep 3
test -e sdl.pid && test -e /proc/$(cat sdl.pid) && exit 0
exit 1
