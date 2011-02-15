#!/bin/bash

. /asdf/common

cat << EOF
===-----------------
This script will duplicate this live cd onto a harddisk.
A new partition will be appended to the hard disk to contain
all necessary data. Therefore, the chosen disk cannot have more
than 3 partitions - for now.
Afterwards, grub will be installed to function as a bootloader, which
boots windows by default and only a userinteraction can change
that - again, for now.
EOF
prompt "Enter the device to install to:"
DEV=$INPUT

start_msg "Adding partition"
(echo -e "n\np\n4\n\n+500M\nt\n4\nb\nw\n" | fdisk $DEV) || die "failed"
blockdev --rereadpt $DEV
sleep 5
success_msg

start_msg "Formatting partition"
mkfs.vfat ${DEV}4 || die "failed"
success_msg

start_msg "Mounting"
mkdir /sysresc || die "Could not create mountfolder"
mount ${DEV}4 /sysresc || die "Could not mount target device"
success_msg

start_msg "Copying files"
mkdir /sysresc/sysrcd || die "Could not write on target device"
for file in sysrcd.dat sysrcd.md5 isolinux/initram.igz isolinux/rescuecd isolinux/rescue64 isolinux/altker32 isolinux/altker64; do
	cp -v /livemnt/boot/$file /sysresc/sysrcd/ || die "Could not copy $file"
done
success_msg

start_msg "Refreshing device map"
grub-mkdevicemap
BIOSDEV=$(cat /boot/grub/device.map | grep $DEV | cut -f1 | sed -r 's![()]!!g')
info_msg "BIOS device: $BIOSDEV"
success_msg
prompt "Correct?"

start_msg "Installing bootloader"
mkdir -p /sysresc/boot/grub
cp -rv /lib/grub/i386-pc/* /sysresc/boot/grub/ || die "Could not copy bootloader files"
(echo -e "root ($BIOSDEV,3)\nsetup ($BIOSDEV)\nquit\n" | grub --batch) || die "Failed"
cat /asdf/library/installer/menu.lst.template \
	> /boot/grub/menu.lst
success_msg

start_msg "Unmounting"
umount /sysresc
rmdir /sysresc
success_msg





