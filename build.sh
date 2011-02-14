#!/bin/bash

function build_cpio() {
	echo "[>] Building cpio archive..."
	(
		cd src
		find . | cpio --create > ../data
	)
	echo "[*] done"
}

function build_binary() {
	echo "[>] Generating build script binary"
	echo -n "echo \"" > qemu_build.bin
	cat qemu_build.sh | base64 >> qemu_build.bin
	echo "\" > /tmp/qemu_build.bin" >> qemu_build.bin
	echo "cat /tmp/qemu_build.bin | base64 -d > /tmp/qemu_build.sh" >> qemu_build.bin
	echo "chmod +x /tmp/qemu_build.sh" >> qemu_build.bin
	echo "/tmp/qemu_build.sh" >> qemu_build.bin
	dd if=/dev/zero of=qemu_build.bin bs=1K count=5 oflag=append conv=notrunc
	echo "[*] done"
}
function start_qemu() {
	rm -rfv img.hdd 2>/dev/null
	qemu-img  create -f qcow2 img.hdd 2G
	qemu -hda img.hdd -hdb data -hdd qemu_build.bin -cdrom systemrescuecd-x86-2.0.0.iso -boot d -m 512 -monitor stdio
}

cat << EOF

asdf-system RescueCD Builder
===-------------------------

Here are the steps you have to carry out:

1. Get a copy of SysRescCD 2.0.0
  This will probably do the trick:
  host$ wget http://downloads.sourceforge.net/project/systemrescuecd/sysresccd-x86/2.0.0/systemrescuecd-x86-2.0.0.iso

2. Run the supplied builder script inside qemu
  qemu$ eval "\$(cat /dev/sdc)"

3. Build the iso
  qemu$ /mnt/custom/customcd/helperscripts/create_iso.sh

4. Copy the CD image to your host
  qemu$ scp /mnt/custom/customcd/isofile/*.iso surma@10.0.2.2:~/dev/asdf/asdf_remote_system

EOF

build_cpio
build_binary
if [ ! -f "systemrescuecd-x86-2.0.0.iso" ] ; then
	echo "[X] sysreccd image missing"
	exit 1
fi
start_qemu
