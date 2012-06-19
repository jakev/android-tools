#!/bin/sh
#
# Jake Valletta, 2012
# Simple shell script to obtain a system.img file for an Android emulator.
# The script assumes the file "mkfs.yaffs2" exists in the current directory
# (this can be obtained from github.com/jakev/android-binaries)

ADB_COMMAND="adb -e "

echo -n "[+] Pushing mkfs.yaffs2 to device..."
$ADB_COMMAND push mkfs.yaffs2 /data/local/

echo "[+] Executing \"chmod 770 /data/local/mkfs.yaffs2\""
$ADB_COMMAND shell chmod 770 /data/local/mkfs.yaffs2

echo "[+] Setting /system partition to read-only (Just to be safe!)"
$ADB_COMMAND shell mount -o ro,remount /dev/block/mtdblock0 /system

echo "[+] Creating YAFFS2 image of /system"
$ADB_COMMAND shell /data/local/mkfs.yaffs2 /system/ /mnt/sdcard/_system.img

echo -n "[+] Pulling image to local directory..."
$ADB_COMMAND pull /mnt/sdcard/_system.img ./

echo -n "[+] Cleaning...."
$ADB_COMMAND shell rm /data/local/mkfs.yaffs2
$ADB_COMMAND shell rm /mnt/sdcard/_system.img
echo "[OK]"
