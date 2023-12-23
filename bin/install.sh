#! /usr/bin/env bash

set -x

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

export PATH=`pwd`/superDoit/bin:`pwd`/GsDevKit_stones/bin:$PATH
versionReport.solo
export GSDEVKIT_STONES_ROOT=`pwd`/GsDevKit_stones
export STONES_DATA_HOME=$XDG_DATA_HOME
if [ "$STONES_DATA_HOME" = "" ] ; then
	# on Mac ensure the directory you choose exists
	export STONES_DATA_HOME=$HOME/.local/share
fi