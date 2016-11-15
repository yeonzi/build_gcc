#!/bin/bash

#set exit if any error
set -e

#Set default target
prefix=/opt/local
binutils=binutils-2.27
gcc=gcc-6.2.0
avr_libc='avr-libc-2.0.0'
thread_free=1

#Check conditions
#Check if sudo
if [ "$(whoami)" != "root" ]; then
	echo -e "Please run it with root\a"
	exit 1
fi

#Check CPU thread
echo "checking cpu thread"
thread=$(sysctl -n hw.ncpu)
echo "Find ${thread} thread on your CPU"
thread_use=$((thread-thread_free))
echo -e "For safty considered, we will use ${thread_use} thread to compile all object\a"
sleep 1


echo "checking binutils"
if [[ -x "$(command -v avr-ld)" ]]; then
	echo "avr-ld already exist."
	echo "Please manual uninstall it if you want to compile it."
	sleep 1
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
		echo "Directory binutils already exist."
		echo "Please remove it if you want to redownload it."
	fi

	#Compile binutil.
	cd ${binutils}
	if [[ -d ./build ]]; then
		rm -rf ./build
	fi
	mkdir build
	cd build
	../configure --target=avr --prefix=${prefix}
	make -j${thread_use} -s
	make -s install
	cd ../..
fi


echo "checking gcc"
if [[ -x "$(command -v avr-gcc)" ]]; then
	echo "avr-gcc already exist."
	echo -e "Please manual uninstall it if you want to compile it.\a"
	sleep 1
else
	#Get gcc
	echo "Checking directory ${gcc}"
	if [[ ! -d ./${gcc} ]]; then
		echo "Directory ${gcc} does not exist."
		echo "Checking ${gcc}.tar.gz"
		if [[ ! -f ./${gcc}.tar.gz ]]; then
			echo "File ${gcc}.tar.gz does not exist."
			echo "Try to get ${gcc}.tar.gz from ftp://ftp.gnu.org"
			ftp ftp://ftp.gnu.org/gnu/gcc/${gcc}/${gcc}.tar.gz
		fi
		echo "unzip ${gcc}.tar.gz"
		tar -xf ${gcc}.tar.gz
	else
		echo "Directory ${gcc} already exist."
		echo "Please remove it if you want to redownload it."
	fi

	#Compile gcc.
	cd ${gcc}
	if [[ -d ./build ]]; then
		rm -rf ./build
	fi
	mkdir build
	cd build
	../configure --target=avr --prefix=${prefix} --enable-fixed-point --enable-languages=c,c++ --enable-long-long --disable-nls --disable-werror
	make -j${thread_use} -s all-gcc
	make -s install-gcc
	cd ../..
fi

echo "Checking directory ${avr_libc}"
if [[ ! -d ./${avr_libc} ]]; then
	echo "Directory ${avr_libc} does not exist."
	echo "Checking ${avr_libc}.tar.bz2"
	if [[ ! -f ./${avr_libc}.tar.bz2 ]]; then
		echo "File ${avr_libc}.tar.gz does not exist."
		echo "Try to get ${avr_libc}.tar.bz2 from http://download.savannah.gnu.org"
		wget http://download.savannah.gnu.org/releases/avr-libc/${avr_libc}.tar.bz2
	fi
	echo "unzip ${avr_libc}.tar.bz2"
	tar -xf ${avr_libc}.tar.bz2
else
	echo "Directory ${avr_libc} already exist."
	echo "Please remove it if you want to redownload it."
fi
cd ${avr_libc}
if [[ -d ./build ]]; then
	rm -rf ./build
fi
mkdir build
cd build
../configure --build=`../config.guess` --host=avr
make -j${thread_use} -s
make -s install
cd ../..

