#!/bin/bash

#set exit if any error
set -e

#Check conditions
#Check if sudo
if [ "$(whoami)" != "root" ]; then
	echo "Please run it with root"
	exit 1
fi

binutils=binutils-2.27

echo "checking binutils"
if [[ -x "$(command -v avr-ld)" ]]; then
	echo "avr-ld already exist."
	echo "Please manual uninstall it if you want to compile it."
	sleep 3
else
	#Get binutils
	echo "Checking directory ${binutils}"
	if [[ ! -d ./${binutils} ]]; then
		echo "Directory binutils does not exist."
		echo "Checking ${binutils}.tar.gz"
		if [[ ! -f ./${binutils}.tar.gz ]]; then
			echo "File ${binutils}.tar.gz does not exist."
			echo "Try to get ${binutils}.tar.gz from ftp://ftp.gnu.org"
			ftp ftp://ftp.gnu.org/gnu/binutils/${binutils}.tar.gz
		fi
		echo "unzip ${binutils}.tar.gz"
		tar -xf ${binutils}.tar.gz
	else
		echo "Directory binutils does not exist."
		echo "Please remove it if you want to redownload it."
	fi

	#Compile binutil.
	cd ${binutils}
	if [[ -d ./build ]]; then
		rm -rf ./build
	fi
	mkdir build
	cd build
	../configure --target=avr --prefix=/opt/local
	make
	make install
fi

