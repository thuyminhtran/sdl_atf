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
```

**2**  ```$ make```


## Run:
``` ./start.sh [options] [script file name] ```
