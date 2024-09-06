#!/bin/sh

set -e

if ! [ $(id -u) = 0 ]; then
    echo "Execute script as root."
    exit 1
fi

if [ $# -ne 2 ] ; then
    echo "$0 SOURCE-DEBIAN DESTINATION-DSTDEVICE"
    exit 1
fi

SRCDEBIAN="$1"

DSTDEVICENAME=$2 # e.g. sdc
DSTDEVICE="/dev/$DSTDEVICENAME" # e.g. /dev/sdc
DSTPARTITION="/dev/${DSTDEVICENAME}1" # e.g. /dev/sdc1
DSTDIR="/tmp/usbstick"

DIR=$(dirname "$(readlink -f "$0")")
GRUB="$DIR/grub.cfg"
SETUP="$DIR/setup.sh"
PRESEED="$DIR/preseed.cfg"

if [ ! -f "$SRCDEBIAN/dists/bookworm/Release" ]; then
    echo "The directory '$SRCDEBIAN' does not seem to contain a debian distribution."
    exit 1
fi

if [ ! -b "$DSTDEVICE" ]; then
    echo "The device '$DSTDEVICE' does not exist."
    exit 1
fi

SIZE=$(blockdev --getsize64 "$DSTDEVICE")
if [ "$SIZE" -lt 1000000000 ]; then
    echo "The device '$DSTDEVICE' is too small."
    exit 1
fi

REMOVABLE=$(cat "/sys/block/$DSTDEVICENAME/removable")
if [ "$REMOVABLE" = 0 ]; then
    echo "The device '$DSTDEVICE' is not a removable device."
    exit 1
fi

if [ ! -f "$GRUB" ]; then
    echo "The file '$GRUB' is not in the current directory."
    exit 1
fi

if [ ! -f "$SETUP" ]; then
    echo "The file '$SETUP' is not in the current directory."
    exit 1
fi

if [ ! -f "$PRESEED" ]; then
    echo "The file '$PRESEED' is not in the current directory."
    exit 1
fi

echo "Unmount existing partitions."

for N in $(seq 1 16); do
    umount "$DSTDEVICE$N" 2>/dev/null || true
done

echo "Create partitions on '$DSTDEVICE'."

parted --script "$DSTDEVICE" mklabel msdos
parted --script "$DSTDEVICE" mkpart primary fat32 0% 100%

sleep 1.0 # sometimes it seems to take some time until they device is ready to be written to

echo "Format '$DSTPARTITION'."

mkfs.vfat "$DSTPARTITION" 1>/dev/null

echo "Mount '$DSTPARTITION'."

umount "$DSTDIR" 2>/dev/null || true
mkdir --parents "$DSTDIR"
mount "$DSTPARTITION" "$DSTDIR"

echo "Copy '$SRCDEBIAN' to '$DSTPARTITION'."

#rsync -a "$SRCDEBIAN" "$DSTDIR" 2>/dev/null || true
# 2>/dev/null || true
rsync --recursive --fsync --times "$SRCDEBIAN" "$DSTDIR" 2>/dev/null

echo "Copy configuration files."

cp grub.cfg "$DSTDIR/boot/grub"
cp preseed.cfg "$DSTDIR"
cp setup.sh "$DSTDIR"

echo "Content of '$DSTPARTITION'"
ls "$DSTDIR"

echo "Unmount '$DSTPARTITION'"
umount "$DSTPARTITION"
