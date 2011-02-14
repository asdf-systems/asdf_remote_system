#!/bin/bash

. /asdf/common

start_msg "Acquiring required data"
prompt "Username:"
USERNAME=$INPUT
prompt "Password:"
PASSWORD=$INPUT
success_msg

start_msg "Generating config"
mkdir -p /etc/ddclient
cat /asdf/library/networking/dyndns/ddclient.conf | \
	sed -r "s!\{username\}!$USERNAME!g" | \
	sed -r "s!\{password\}!$PASSWORD!g" \
	> /etc/ddclient/ddclient.conf
success_msg

start_msg "Adding dyndns to autostart"
cat /asdf/library/networking/dyndns/10_dyndns.sh.template \
	> /asdf/autorun/10_dyndns.sh
success_msg
