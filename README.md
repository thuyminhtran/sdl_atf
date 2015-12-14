# Automated Test Framework (ATF)
Current release version: 2.2 (https://github.com/CustomSDL/sdl_atf/releases/tag/ATF2.2)

## Dependencies:
lua5.2
liblua5.2-dev
Qt5

## Get source code:
```
$ git clone https://github.com/CustomSDL/sdl_atf
$ cd sdl_atf
$ git submodule init
$ git submodule update
```
## Compilation:
**1**  Setup path to qmake in Makefile ``` QMAKE=${PATH_TO_QMAKE} ``` *You can get path to qake this way:*
```
$ where qmake
/usr/bin/qmake
/opt/Qt5.4.1/5.4/gcc/bin/qmake
#/usr/bin/qmake in most cases does not work as it is just soft link to qtchooser

**2**  ```$ make```

# 1) If during executing "make" command you have the following problem:
#
#   Project ERROR: Unknown module(s) in QT: websockets
#
#   Solution:
#    You have to chage location of qmake in Makefile in atf root directory
#    Find location of qmake executable on your local PC:
#    (It should look like: .../Qt/5.4/gcc_64/bin/qmake)
#
#    and put it into Makefile to the line:
#    QMAKE=<your path to qmake>
#   Sometimes you will need reinstall QT Creator to get correct qmake executable
#   Also you can open QT Creator. Then go to: Tool->Options->Build & Run. Find Qt Versions Tab.
#   Here you can find qmake location
#
# 2) If you have the followong problem:
#
#   libavcall.a is missing
#
#   Solution: sudo apt-get install libffcall1-dev

## Run:
``` ./start.sh [options] [script file name] ```
