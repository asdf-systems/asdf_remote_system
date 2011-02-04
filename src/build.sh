#!/bin/bash

cd /mnt/custom/customcd
. helperscripts/common

for file in helperscripts/*.sh; do
	start_msg "Running $file"
	./$file
done
