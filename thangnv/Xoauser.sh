#!/bin/bash
cat > simple.txt << "EOF"
hungld
phuonglh
tunt
minhdt
bachnt
tienbm
hungnv
quyetnd
sontn
dont
linhnv2
sysadmin
games
ducnn
EOF
user=(`cat simple.txt`)
COUNTER=0
while [  $COUNTER -lt 15 ]; do
	userdel ${user[$COUNTER]}
	let COUNTER=COUNTER+1
	echo "${user[$COUNTER]}"
done
rm -rf simple.txt