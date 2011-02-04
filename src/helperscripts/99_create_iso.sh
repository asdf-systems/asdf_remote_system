#!/bin/bash

. /mnt/custom/customcd/helperscripts/common
cd /mnt/custom/customcd

rm -rf files/asdf
cat /dev/sdb | cpio --extract || die "Could not extract custom data"
sysresccd-custom squashfs || die "Could not create squashfs"
sysresccd-custom isogen asdfix || die "Could not create iso image"
