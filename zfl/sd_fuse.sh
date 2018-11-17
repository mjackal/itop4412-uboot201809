#!/bin/sh

###############################################
# shell script for SD, exynos4412
# @author zfling
# @date 2018-11-16
###############################################
if [ -z $1 ]
then
    echo "usage: ./sd_fusing.sh <SD Reader's device file>"
    exit 0
fi

if [ -b $1 ]
then
    echo "$1 reader is identified."
else
    echo "$1 is NOT identified."
    exit 0
fi

####################################
# verify device
BDEV_NAME=`basename $1`
BDEV_SIZE=`cat /sys/block/${BDEV_NAME}/size`

if [ ${BDEV_SIZE} -le 0 ]; then
	echo "Error: No media found in casr reader."
	exit 1
fi

if [ ${BDEV_SIZE} -gt 32000000 ]; then
	echo "Error: Block device size (${BDEV_SIZE}) is too large."
	exit 1
fi

####################################
# check files
# UBOOT = ../u-boot.bin
MKBL2=./mkbl2

#<make bl2>
${MKBL2} ./u-boot-spl.bin bl2.bin 14336

####################################
# fusing images

signed_bl1_position=1
bl2_position=17
uboot_position=81
tzsw_position=1105

#<bl1 fusing>
echo "--------------------------------------"
echo "BL1 fusing"
dd iflag=dsync oflag=dsync if=./E4412_N.bl1.bin of=$1 seek=$signed_bl1_position

#<bl2 fusing>
echo "--------------------------------------"
echo "BL2 fusing"
dd iflag=dsync oflag=dsync if=./bl2.bin of=$1 seek=$bl2_position

#<uboot fusing>
echo "--------------------------------------"
echo "Uboot fusing"
dd iflag=dsync oflag=dsync if=./u-boot.bin of=$1 seek=$uboot_position


####################################
#<Message Display>
echo "--------------------------------------"
echo "U-boot image is fused successfully"
echo "Eject SD card and insert it again"
