#!/bin/bash

. /mnt/custom/customcd/helperscripts/common
cd /mnt/custom/customcd

rm -rf files/asdf
cat /dev/sdb | cpio --extract
sysresccd-custom squashfs
sysresccd-custom isogen asdfix
