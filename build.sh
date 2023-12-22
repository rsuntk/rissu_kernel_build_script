#! /bin/bash
# Rissu Kernel Builder Script.

# Rissu Copyright (C) 2023
# Rissu Projekt Copyright (C) 2023

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

# Start of "Export" variable
## Example: ANDROID_MAJOR_VERSION=q/r/s/t/u [q = 10, r = 11, s = 12, t = 13, u = 14]
export ANDROID_MAJOR_VERSION=r ;
ANDROID_CODE=$ANDROID_MAJOR_VERSION

## Example: ARCH=arm64 for arm64, or arm for arm32 arch
export ARCH= ;

## Example: SUBARCH=$ARCH or SUBARCH=arm. (usually, arm64)
export SUBARCH= ;

## Example: DEFCONFIG=a10s_defconfig
export DEFCONFIG= # Put your defconfig here.

## Ur username and Host name.
export KBUILD_BUILD_USER=$(whoami)
export KBUILD_BUILD_HOST=$(hostname)

## Install missing libs? [y = Install missing lib | n = Everything's ready, no need to install missing libs.]
INSTALL_MISSING_LIBS=n

## Example: /home/rissu/aarch64-linux-android-4.9/bin/aarch64-linux-android-
#export CROSS_COMPILE=

## Example: /home/rissu/clang-r383902/bin/clang
#export CC=

## Info: 
#	KERNEL_IMAGE_TYPE is neither zImage or Image or bzImage (Samsung usually use Image)
#	KERNEL_EXTENSION_TYPE is gz/gz-dtb
# 	A10s (OneUI 2 fw): gz-dtb
# 	A10s (OneUI 3 fw): gz
KERNEL_IMAGE_TYPE=Image
KERNEL_EXTENSION_TYPE=gz

# End of "Export" variable
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- #

## Determine android version, code and codenames
if [ $ANDROID_CODE = "q" ]; then
	UNEXPORTED_PLATFORM_VERSION=10;
	UNEXPORTED_ANDROID_CODENAME="Quince Tart";
elif [ $ANDROID_CODE = "r" ]; then
	UNEXPORTED_PLATFORM_VERSION=11;
	UNEXPORTED_ANDROID_CODENAME="Red Velved Cake";
elif [ $ANDROID_CODE = "s" ]; then
	UNEXPORTED_PLATFORM_VERSION=12;
	UNEXPORTED_ANDROID_CODENAME="Snow Cone";
elif [ $ANDROID_CODE = "t" ]; then
	UNEXPORTED_PLATFORM_VERSION=13;
	UNEXPORTED_ANDROID_CODENAME="Tiramisu";
elif [ $ANDROID_CODE = "u" ]; then
	UNEXPORTED_PLATFORM_VERSION=14;
	UNEXPORTED_ANDROID_CODENAME="Upside Down Cake";
fi

export PLATFORM_VERSION=$UNEXPORTED_PLATFORM_VERSION
export ANDROID_CODENAME=$UNEXPORTED_ANDROID_CODENAME

# Start of Important variable

## Colors
GREEN='\033[1;32m'
RED='\033[1;31m' 
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

## Text Format & Functions
CURRENT_DATE=`date`
BOLD=$(tput bold)
HIGHLIGHT=$(tput smso)
UNHIGHLIGHT=$(tput rmso)
CURRENT_FILENAME=$(basename "$0")

# End of Important variable

### Start of Build msg
# Start of Functions
## Message functions
install_missing_libs() {
	printf "${YELLOW}  INST_LIB\t\tMissing required library to build${NC}\n";
	# If you're using Github Dev or Gitpod, these library usually didn't installed.
	sudo apt update && sudo apt install cpio bc flex aptitude python-is-python3 -y;
	# Get libssl-dev from Aptitude
	sudo aptitude install libssl-dev -y;
};
make_cmd() {
	# Make command now separated as a function.
	make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y ;
};
build_summary() {
	if ! test -f $(pwd)/config.cfg; then
		config_missing;
	fi
	echo "\n\tRissu Kernel Build Script\n\tRissu Copyright (C) 2023";
	
	printf "${GREEN}\n  INIT\t\tPreparing build environment";
	echo "";
	printf "${BLUE}\n  SUMMARY\tAndroid Code: $ANDROID_MAJOR_VERSION\n  SUMMARY\tAndroid Codename: $ANDROID_CODENAME\n  SUMMARY\tAndroid Version: $PLATFORM_VERSION\n  SUMMARY\tArchitecture: $ARCH\n  SUMMARY\tDefconfig: $DEFCONFIG\n  SUMMARY\tBuild User: $KBUILD_BUILD_USER\n  SUMMARY\tBuild Host: $KBUILD_BUILD_HOST${GREEN}";
	echo "";
};
err_directory_not_found() {
	printf "${RED}  ERROR\t\tDirectory ${HIGHLIGHT}'$(pwd)/out'${UNHIGHLIGHT} didn't exist, use flag --zero to start zero build.\n${NC}";
};
completed() {
	printf "${GREEN}\n### Build completed at $CURRENT_DATE ### \n\n";
};
failed() {
	printf "${RED}\n### Build failed at $CURRENT_DATE ### \n\n";
};
remove_out() {
	printf "${YELLOW}  REMOVE\t$(pwd)/out\n${NC}";
	rm -rR out
};
unset_var() {
	unset PLATFORM_VERSION;
	unset ANDROID_CODENAME;
	unset ARCH;
	unset SUBARCH;
	unset KBUILD_BUILD_HOST;
	unset KBUILD_BUILD_USER;
	unset ANDROID_MAJOR_VERSION;
	#unset CC;
	#unset CROSS_COMPILE;
};
prompt_failure() {
	clear;
	printf "\n${RED}Failed, build aborted. Missing value.\n";
	exit;
};
## Upcoming features ..
#prompt_build() {
#	clear;
#	printf "\n${YELLOW}No argument detected. Starting prompt build ..${NC}\n";
#	printf "\n${BOLD}## Example: DEFCONFIG=a10s_defconfig${NC}\n";
#	read -p "DEFCONFIG=" PROMPT_DEFCONFIG;
#	printf "\n${BOLD}## Example: ARCH=arm64${NC}\n";
#	read -p "ARCH=" PROMPT_ARCH;
#	printf "\n${BOLD}## Example: ANDROID_MAJOR_VERSION=r [r = android 11]${NC}\n";
#	read -p "ANDROID_MAJOR_VERSION=" PROMPT_ANDROID_CODE;
#	printf "\n\n${BOLD}## Build Type: CLEAN, DIRTY & ZERO.${NC}\n";
#	read -p "BUILD_TYPE=" PROMPT_BUILD_TYPE;
#	
#	export DEFCONFIG=$PROMPT_DEFCONFIG;
#	export ARCH=$PROMPT_ARCH;
#	export ANDROID_MAJOR_VERSION=$PROMPT_ANDROID_CODE;
#	if [ $PROMPT_BUILD_TYPE = "clean" ] || [ $PROMPT_BUILD_TYPE = "Clean" ] || [ $PROMPT_BUILD_TYPE = "CLEAN" ]; then
#		clean_build;
#	elif [ $PROMPT_BUILD_TYPE = "dirty" ] || [ $PROMPT_BUILD_TYPE = "Dirty" ] || [ $PROMPT_BUILD_TYPE = "DIRTY" ]; then
#		dirty_build;
#	elif [ $PROMPT_BUILD_TYPE = "zero" ] || [ $PROMPT_BUILD_TYPE = "Zero" ] || [ $PROMPT_BUILD_TYPE = "ZERO" ]; then
#		zero_build;
#	else
#		prompt_failure;
#	fi
#	unset_var;
#};
#
#
#generate_config() {
#	CONFIG_FILE="
#	# RKBS Configuration.
#	# Edit if neccessary.
#	ARCH=$ARCH;
#	ANDROID_MAJOR_VERSION=$ANDROID_CODE;
#	DEFCONFIG=$defconfig;
#	KBUILD_BUILD_HOST=$KBUILD_BUILD_HOST;
#	KBUILD_BUILD_USER=$KBUILD_BUILD_USER;
#	";
#	
#	echo $CONFIG_FILE >> config.cfg
#};

## PREPARE BUILD ENVIRONMENT
if [ $INSTALL_MISSING_LIBS = "y" ]; then
	install_missing_libs;
fi

## Build functions
clean_build() {
	build_summary;
	# Clean build means cleaning "out" folder, so last successfully/failed compiled kernel build will be removed.
	printf "\n${GREEN}  INIT\t\tStarting clean build\n${NC}";
	if ! test -d $(pwd)/out; then
		err_directory_not_found;
		failed;
		exit 0;
	else
		remove_out;
	fi
	   
	make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y $(echo $DEFCONFIG) ;
	make_cmd;
	if ! test -f $(pwd)/out/arch/$ARCH/boot/$KERNEL_IMAGE_TYPE.$KERNEL_EXTENSION_TYPE; then
  		failed
	else
  		completed
	fi
	unset_var;
	exit
};

zero_build() {
	build_summary;
	printf "\n${GREEN}  INIT\t\tStarting zero build\n${NC}";
	make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y $(echo $DEFCONFIG) ;
	make_cmd;
	if ! test -f $(pwd)/out/arch/$ARCH/boot/$KERNEL_IMAGE_TYPE.$KERNEL_EXTENSION_TYPE; then
  		failed
	else
  		completed
	fi
	unset_var;
	exit
};

dirty_build() {
	build_summary;
	printf "\n${GREEN}  INIT\t\tStarting dirty build\n${NC}";
	make_cmd;
	if ! test -f $(pwd)/out/arch/$ARCH/boot/$KERNEL_IMAGE_TYPE.$KERNEL_EXTENSION_TYPE; then
  		failed
	else
  		completed
	fi
	unset_var;
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
	printf "\n${RED}ERROR: No argument detected. use --help to show script usage.\n${NC}";
fi

#prompt_build;
