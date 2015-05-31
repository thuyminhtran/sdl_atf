dirsSDL=$1
dirsATF=$(pwd)
cd $dirsSDL
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:. export LD_LIBRARY_PATH
xterm -e ./smartDeviceLinkCore &
cd $dirsATF 
touch sdl.pid
echo $! > sdl.pid
sleep 3
test -e sdl.pid && test -e /proc/$(cat sdl.pid) && exit 0
exit 1
