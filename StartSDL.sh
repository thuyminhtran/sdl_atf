#!/bin/bash
dirsSDL=$1
dirsATF=$(pwd)
nameApplication=$2
cd $dirsSDL
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:. export LD_LIBRARY_PATH
./$nameApplication &
cd $dirsATF 
touch sdl.pid
echo $! > sdl.pid
sleep 3
test -e sdl.pid && test -e /proc/$(cat sdl.pid) && exit 0
exit 1
