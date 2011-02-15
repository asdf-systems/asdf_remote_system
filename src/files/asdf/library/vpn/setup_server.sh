#!/bin/bash

. /asdf/common
cd /usr/share/openvpn/easy-rsa
prompt "Enter the networks name:" || die "Aborted"
NAME=$INPUT
TARDIR=/etc/openvpn/$NAME

start_msg "Creating configuration folder"
mkdir -p $TARDIR/keys || die "Failed"
rm keys
chmod go-rwx $TARDIR/keys
touch $TARDIR/keys/index.txt
echo 01 > $TARDIR/keys/serial
ln -sf $TARDIR/keys .
success_msg

start_msg "Cleaning stray files"
. ./vars || die "Failed to load default values"
success_msg

start_msg "Generating server certificate"
cat << EOF
The default values of the following prompts should
suffice in most cases.
However, do remember to fill out the "Common Name"
[Press Enter to continue]
EOF
read
./build-ca || die "Failed to build certificate authority"
success_msg

start_msg "Generating server key"
cat << EOF
===-----------
Again, all values can probably be defaulted
When the common name is asked, use "server".
Don't use a passphrase.
Answer "y" to all signing requests.
[Press Enter to continue]
EOF
read
./build-key-server server || die "Failed to generate keys"
success_msg

start_msg "Generating Diffie-Hellman parameters"
./build-dh || die "Failed"
success_msg

cat << EOF
===-------------
Summary:
All necessary files were successfully generated:
	ca.crt
		Description: The root certificate
		Needed by:   Server and all clients
		Secret:      No
	ca.key
		Description: The signing key
		Needed by:   The key signing machine (likely to be this machine)
		Secret:      Yes
	dh*.pem
		Description: Diffie Hellman Parameters
		Needed by:   Server
		Secret:      No
	server.crt
		Description: Server certificate
		Needed by:   Server
		Secret:      No
	server.key
		Description: Server key
		Needed by:   Server
		Secret:      Yes

All files are in $TARDIR/keys
[Press Enter to continue]
EOF
read

start_msg "Generating config"
cat /asdf/library/vpn/openvpn.conf.template \
	> $TARDIR/openvpn.conf
success_msg

start_msg "Adding OpenVPN to autostart"
cat /asdf/library/vpn/20_openvpn.sh.template | \
	sed -r "s!\{name\}!$NAME!g" \
	> /asdf/autorun/20_openvpn_$NAME.sh
chmod +x /asdf/autorun/20_openvpn_$NAME.sh
success_msg

start_msg "Cleaning up"
rm keys
success_msg

