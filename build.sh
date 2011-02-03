#!/bin/bash

function build_cpio() {
	echo "[>] Building cpio archive..."
	(
		cd src
		find ./files ./isoroot | cpio --create > ../data
	)
	echo "[*] done"
}

cat << EOF

asdf-system RescueCD Builder
===-------------------------

Sorry, this is not fully automated.
Here are the steps you have to carry out:

1. Get a copy of SysRescCD 2.0.0
  This will probably do the trick:
  host$ wget http://downloads.sourceforge.net/project/systemrescuecd/sysresccd-x86/2.0.0/systemrescuecd-x86-2.0.0.iso

2. Boot it up in some kind of emulator (e.g. Qemu)
  host$ qemu-img  create -f qcow2 img.hdd 2G
  host$ qemu -hda img.hdd -hdb data -cdrom systemrescuecd-x86-2.0.0.iso -boot d

3. Extract the CD image
  qemu$ mkfs.ext2 /dev/sda
  qemu$ mount /dev/sda /mnt/custom
  qemu$ sysresccd-custom extract

4. Copy the folder contents to the vm
  qemu$ cd /mnt/custom/customcd
  qemu$ cat /dev/sdb | cpio --extract

5. Build the new CD image
  qemu$ sysresccd-custom squashfs
  qemu$ sysresccd-custom isogen asdfix

6. Copy the CD image to your host
  qemu$ scp /mnt/custom/customcd/isofile/*.iso surma@10.0.2.2:~/dev/asdf/asdf_remote_system

I will now to the one automatic step for you.
EOF

build_cpio
