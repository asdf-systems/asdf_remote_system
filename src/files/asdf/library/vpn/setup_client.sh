#!/bin/bash

. /asdf/common
cd /usr/share/openvpn/easy-rsa
prompt "Enter the network's name:" || die "Aborted"
NAME=$INPUT
TARDIR=/etc/openvpn/$NAME
prompt "Enter the client's name (equals name of the key files):" || die "Aborted"
CNAME=$INPUT
prompt "Enter the server to connect to:" || die "Aborted"
SERVER=$INPUT

start_msg "Creating configuration folder"
mkdir -p $TARDIR/keys || die "Failed"
rm keys
chmod go-rwx $TARDIR/keys
touch $TARDIR/keys/index.txt
echo 01 > $TARDIR/keys/serial
ln -sf $TARDIR/keys .
success_msg

start_msg "Generating config"
cat /asdf/library/vpn/openvpn.conf.client.template \
	| sed -r "s!\{name\}!$CNAME!g" \
	| sed -r "s!\{server\}!$SERVER!g" \
	> $TARDIR/openvpn.conf
success_msg

start_msg "Adding OpenVPN to autostart"
cat /asdf/library/vpn/20_openvpn.sh.template \
	| sed -r "s!\{name\}!$NAME!g" \
	> /asdf/autorun/20_openvpn_$NAME.sh
chmod +x /asdf/autorun/20_openvpn_$NAME.sh
success_msg

start_msg "Cleaning up"
rm keys
success_msg

