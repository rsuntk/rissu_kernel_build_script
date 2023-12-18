#! /bin/bash
# Rissu Kernel Builder Script.
# Rissu Projekt (rsuprjkt) Copyright (C) 2023

# This script is used in Samsung's kernel source.

# Start of "Export" variable
## Example: ANDROID_MAJOR_VERSION=q/r/s/t/u (q = 10, r = 11, s = 12, t = 13, u = 14}
export ANDROID_MAJOR_VERSION= ;

## Example: PLATFORM_VERSION=10 means for Android 10.
export PLATFORM_VERSION= ;

## Example: ARCH=arm64 for arm64, or arm for arm32 arch
export ARCH= ;

## Same as ARCH.
export SUBARCH= ;

## Example: a10s_defconfig
export DEFCONFIG= # Put your defconfig here.

## Ur username and Host name.
export KBUILD_BUILD_USER=$(whoami)
export KBUILD_BUILD_HOST=$(hostname)

## Example: /home/rissu/clang-r383902/bin/clang
#export CC=

## Example: gz/lz4
# A10s (OneUI 2 fw): gz-dtb
# A10s (OneUI 3 fw): gz
extension_type=

## Example: /home/rissu/aarch64-linux-android-4.9/bin/aarch64-linux-android-
#export CROSS_COMPILE=

# End of "Export" variable

# Start of Important variable
GREEN='\033[1;32m'
RED='\033[1;31m' 
NC='\033[0m'
get_current_date=`date`
bold=$(tput bold)
highlight=$(tput smso)
rm_highlight=$(tput rmso)
current_filename=$(basename "$0")
# End of Important variable

# Start of Functions
## Message functions
build_summary() {
	printf "${bold}\n-- Preparing build environment";
	echo "";
	echo "# ------------- INFO ------------- #";
	# Start of Quick Summary
	echo "# Android Code: $ANDROID_MAJOR_VERSION";
	echo "# Android Version: $PLATFORM_VERSION";
	echo "# Architecture: $ARCH";
	echo "# Defconfig: $DEFCONFIG";
	echo "# Build User: $KBUILD_BUILD_USER";
	echo "# Build Host: $KBUILD_BUILD_HOST";
	# End of Quick Summary
	echo "# ------------- INFO ------------- #";
	echo "";
}
err_directory_not_found() {
	printf "${RED}! ERROR: Directory ${highlight}'$(pwd)/out'${rm_highlight} didn't exist, use flag --zero to start zero build.\n${NC}";
}

completed() {
	printf "${GREEN}\n*** Compilation completed at $get_current_date *** \n\n";
}

failed() {
	printf "${RED}\n*** Compilation failed at $get_current_date *** \n\n";
}

## Build functions
clean_build() {
	build_summary;
	# Clean build means cleaning "out" folder, so last successfully/failed compiled kernel build will be removed.
	echo "-- Starting clean build";
	if ! test -d $(pwd)/out; then
		err_directory_not_found;
		failed;
		exit 0;
	else
		rm -rR out
	fi
	   
	make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y $(echo $DEFCONFIG) ;
	make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y ;
	if ! test -f $(pwd)/out/arch/$ARCH/boot/Image.$extension_type; then
  		failed
	else
  		completed
	fi
	exit
};

zero_build() {
	build_summary;
	echo "-- Starting zero build";
	make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y $(echo $DEFCONFIG) ;
	make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y ;
	if ! test -f $(pwd)/out/arch/$ARCH/boot/Image.$extension_type; then
  		failed
	else
  		completed
	fi
	exit
};

dirty_build() {
	build_summary;
	echo "-- Starting dirty build";
	make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y ;
	if ! test -f $(pwd)/out/arch/$ARCH/boot/Image.$extension_type; then
  		failed
	else
  		completed
	fi
	exit
};
# End of Functions

while test $# -gt 0; do
  case "$1" in
    --clean)
      shift
      clean_build
      ;;
    --zero)
      shift
      zero_build
      ;;
    --dirty)
      shift
      dirty_build
      ;;
    --help)
      shift
      printf "Rissu Kernel Builder Script\nHow to use: $ sh $current_filename [ARGS]\nAvailable arguments:\n\t--clean - Do a clean build.\n\t--dirty - Do a dirty build.\n\t--zero  - Do a zero build.\n\t--help  - How to use this script.\n\n";
      exit 0;
      ;;
  esac
done

if ! test $# -gt 0; then
    printf "${RED}! ERROR: No argument. Use --help for information\n";
    exit
fi
