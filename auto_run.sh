#!/bin/bash
echo "Clean Configuration File..." 
rm -f zfl/u-boot.bin
rm -f zfl/u-boot-spl.bin
make distclean 
echo "Clean Obj..." 
make clean
echo "Load Configuration File..." 
make itop4412_defconfig 
echo "make..."
make CROSS_COMPILE=arm-linux-gnueabi-
if [ -f "spl/u-boot-spl.bin" ];then
	cp spl/u-boot-spl.bin zfl/u-boot-spl.bin
fi
if [ -f "u-boot.bin" ];then
	cp u-boot.bin zfl/u-boot.bin
fi
