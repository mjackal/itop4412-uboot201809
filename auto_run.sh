#!/bin/bash
echo "Clean Configuration File..." 
make distclean 
echo "Clean Obj..." 
make clean
echo "Load Configuration File..." 
make itop4412_defconfig 
echo "make..."
make CROSS_COMPILE=arm-linux-gnueabi-
