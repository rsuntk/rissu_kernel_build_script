# Rissu Kernel Builder Script
## What is this?
A script to build samsung kernel.

## How to use?
### First, change some build variable
Edit the build.sh, and change this:
```
DEFCONFIG=
ANDROID_MAJOR_VERSION=
PLATFORM_VERSION=
ARCH=
SUBARCH=
CROSS_COMPILE= # This is optional, you can change this in Makefile
CC= # This is optional, you can change this in Makefile
```
### Second, Open terminal, and type
```
$ sh build.sh [ARGS]
```
### Available arguments
Argument   | Function
-------:|:-------------------------
```--clean```     | Do a clean build.
```--dirty``` | Do a dirty build.
```--zero```     | Do a zero build.
```--help```  | Show script usage.

### What is the differences between clean, dirty and zero build?
```
clean build: delete 'out' folder (so last successfully or failed compiled kernel will be removed), and then compiling.
dirty build: build the kernel after a failure or canceled compilation. This dirty build method may broke something.
zero build: build the kernel from zero (no 'out' folder yet).
```
