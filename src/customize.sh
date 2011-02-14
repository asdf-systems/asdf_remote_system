#!/bin/bash

cd /mnt/custom/customcd
. helperscripts/common

for file in helperscripts/automatic/*.sh; do
	start_msg "Running $file"
	./$file
done
