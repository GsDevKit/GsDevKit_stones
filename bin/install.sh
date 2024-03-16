#! /usr/bin/env bash

set -x

# Setup GemStone directories
if [ ! -d "/opt/gemstone" ]; then
	echo "Creating /opt/gemstone to store lock files used by GemStone"
	sudo mkdir -p /opt/gemstone
	sudo chmod oug+rwx /opt/gemstone
	sudo mkdir /opt/gemstone/locks
	sudo chmod oug+rwx /opt/gemstone/locks
fi

gsDevKitStones="`dirname $0`/.."
cd $gsDevKitStones/..

if [ "$CI" = "true" ]; then
	# set CI to true to use https to clone superDoit using https instead of ssh"
	gitUrl="https://github.com/dalehenrich/superDoit.git"
else
	gitUrl="git@github.com:dalehenrich/superDoit.git"
fi
git clone $gitUrl -b v4.2
cd superDoit/bin
./install.sh
