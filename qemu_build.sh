#!/bin/bash

function die() {
	echo "$@ failed"
}

mkfs.ext2 -F /dev/sda || die "Creating ext2"
mount /dev/sda /mnt/custom || die "Mounting disk image"
sysresccd-custom extract || die "Extracting disk image"
cd /mnt/custom/customcd
cat /dev/sdb | cpio --extract || die "Extracting patches"
/mnt/custom/customcd/customize.sh || die "Applying patches"
