#!/bin/bash

. common

start_msg "Start patchin files"
cd /mnt/custom/customcd/patches
find . -type f | while read file; do
	patch "/mnt/custom/customcd/files/$file" $file || \
		warning_msg "Failed to patch $file"
done
success_msg
