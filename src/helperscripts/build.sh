#!/bin/bash

for file in *.sh; do
	start_msg "Running $file"
	$file
done
