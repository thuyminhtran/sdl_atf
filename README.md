# Automated Test Framework (ATF)
Current release version: 2.2 (https://github.com/CustomSDL/sdl_atf/releases/tag/ATF2.2)

## Dependencies:
- lua5.2
- liblua5.2-dev
- [Qt5](http://www.qt.io/download-open-source/#section-2)

## Get source code:
```
$ git clone https://github.com/CustomSDL/sdl_atf
$ cd sdl_atf
$ git submodule init
$ git submodule update
```
## Compilation:
**1**  Setup QMAKE enviroment vaeriable to path to qmake
```export QMAKE=${PATH_TO_QMAKE} ``` 
*You can get path to qmake this way:*
```
$ where qmake
/usr/bin/qmake
/opt/Qt5.4.1/5.4/gcc/bin/qmake
```
/usr/bin/qmake in most cases does not work as it is just soft link to qtchooser

**2**  ```$ make```

 1) If during executing "make" command you have the following problem:
   Project ERROR: Unknown module(s) in QT: websockets

   Solution:
   You have to chage location of qmake in Makefile in atf root directory
   Find location of qmake executable on your local PC:
   (It should look like: .../Qt/5.4/gcc_64/bin/qmake)

   and put it into Makefile to the line:
   QMAKE=<your path to qmake>
   Sometimes you will need reinstall QT Creator to get correct qmake executable
   Also you can open QT Creator. Then go to: Tool->Options->Build & Run. Find Qt Versions Tab.
   Here you can find qmake location.


## Run:
**3**
``` ./start.sh [options] [script file name] ```
