#!/bin/bash

. /asdf/common
cd /usr/share/openvpn/easy-rsa
prompt "Enter the network's name:" || die "Aborted"
NAME=$INPUT
TARDIR=/etc/openvpn/$NAME

prompt "Enter client's name:" || die "Aborted"
NAME=$INPUT
rm keys
ln -sf $TARDIR/keys .
. ./vars

start_msg "Generating client certificate"
cat << EOF
The default values of the following prompts should
suffice in most cases.
However, do remember to fill out the "Common Name" with "$NAME"
[Press Enter to continue]
EOF
read
./build-key $NAME || die "Failed to build client key"
success_msg

cat << EOF
===-------------
Summary:
All necessary files were successfully generated:
	$NAME.crt
		Description: The client's certificate
		Needed by:   Client only
		Secret:      No
	$NAME.key
		Description: The client's key
		Needed by:   Client only
		Secret:      Yes

All files are in $TARDIR/keys
[Press Enter to continue]
EOF
read

start_msg "Cleaning up"
rm keys
success_msg

