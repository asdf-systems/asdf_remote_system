#!/bin/bash

. /asdf/autorun/common

start_p "Deleting root password..."
passwd -d root || die "failed"
success_p "done"

start "Opening reverse tunnel..."
(
	while true; do
		ssh -NR 23005:localhost:22 asdf-systems.de
	done
) &>/var/log/asdf/$0 &
success_p "done"
