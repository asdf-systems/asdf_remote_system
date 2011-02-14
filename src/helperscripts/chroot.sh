#!/bin/bash

ROOT=/mnt/custom/customcd/files
mount -t proc proc $ROOT/proc
mount -t sysfs none $ROOT/sys
mount -o bind /dev $ROOT/dev
chroot $ROOT /bin/bash
umount $ROOT/dev
umount $ROOT/sys
umount $ROOT/proc
