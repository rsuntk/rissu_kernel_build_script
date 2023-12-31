# Rissu Kernel Builder Script
> Currently, only support Debian based distros.
## What is this?
<p>
A script to build samsung kernel.
Not simple, but make it easier.
</p>

## How to use?
### First, change some build variable
Edit the build.sh, and change this:
```
DEFCONFIG= # Define a file that contains device configurations (required)
ANDROID_MAJOR_VERSION= # Define android codename (optional)
PLATFORM_VERSION= # Define android version codename (optional)
ARCH= # Define kernel arch (required)
SUBARCH= # Define kernel sub-arch (optional)
CROSS_COMPILE= # Define cross compiler path (required, but you can change it in makefile instead)
CC= # Define clang/cross compiler path (required, but you can change it in makefile instead)
KERNEL_IMAGE_TYPE= # Define kernel image type (required)
KERNEL_EXTENSION_TYPE= # Define kernel extension type (required)
INSTALL_MISSING_LIBS= # Install some missing libs (optional/required)
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
```--version``` | Script version.

### What is the differences between clean, dirty and zero build?
```
- clean build: delete 'out' folder (so last successfully or failed compiled kernel will be removed), and then compiling.
- dirty build: build the kernel after a failure or canceled compilation. This dirty build method may broke something.
- zero build: build the kernel from zero (no 'out' folder yet).
```
