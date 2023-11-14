#! /usr/bin/env bash

if [ "$CI" = "true" ]; then
	# set CI to true to use https to clone superDoit using https instead of ssh"
	gitUrl="https://github.com/dalehenrich/superDoit.git"
else
	gitUrl="git@github.com:dalehenrich/superDoit.git"
fi
git clone $gitUrl -b v4.2
cd superDoit/bin
./install.sh
