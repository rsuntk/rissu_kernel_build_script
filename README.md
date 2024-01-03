<h1 align="center">Rissu Kernel Builder Script</h1>

#### Note:
- **Currently, only support _Debian_ based distros.**
- **Only support for non-GKI Kernel**
## What is this?
A script to build samsung kernel. Not simple, but make it easier.

## How to use?
### First, change some build variable
Edit the build.sh, and change this variable:
******************************************************
#### DEFCONFIG=
*# Define a file that contains device configurations (required)*

#### ANDROID_MAJOR_VERSION=
*# Define android codename (optional)*

#### PLATFORM_VERSION=
*# Define android version codename (optional)*

#### ARCH=
*# Define kernel arch (required)*

#### SUBARCH=
*# Define kernel sub-arch (optional)*

#### CROSS_COMPILE=
*# Define aarch64-linux-android compiler path (required, but you can change it in makefile instead)*

#### CC=
*# Define clang path (required, but you can change it in makefile instead)*

#### CLANG_TRIPLE=
*# Define aarch64-linux-gnu compiler path (required, but you can change it in makefile instead)*

#### KERNEL_IMAGE_TYPE=
*# Define kernel image type (required)*

#### KERNEL_EXTENSION_TYPE=
*# Define kernel extension type (required)*

#### TOTAL_THREAD=
*# Define PC's total thread for compiling (optional)*

#### INSTALL_MISSING_LIBS=
*# Install some missing libs (optional/required)*

******************************************************
### Second, Open terminal, and type
```
$ ./build [ARGS]
```
or Prompt build
```
$ ./build
```
### Available arguments
Argument   | Function
-------:|:-------------------------
```--clean```     | Do a clean build.
```--dirty``` | Do a dirty build.
```--zero```     | Do a zero build.
```--help```  | Show script usage.

### What is the differences between clean, dirty and zero build?
#### Clean build: 
Delete 'out' folder (so last successfully or failed compiled kernel will be removed), and then compiling.
#### Dirty build: 
Build the kernel after a failure or canceled compilation. This dirty build method may broke something.
#### Zero build: 
Build the kernel from zero (no 'out' folder yet).
