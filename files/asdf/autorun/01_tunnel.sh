#!/bin/bash

. /asdf/autorun/common

start_msg "Deleting root password..."
passwd -d root || die "failed"
success_msg "done"

start_msg "Opening reverse tunnel..."
(
	while true; do
		ssh -NR 23005:localhost:22 asdf-systems.de
	done
) &>/var/log/asdf/tunnel &
success_msg "done"
