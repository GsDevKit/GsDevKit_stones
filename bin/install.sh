#! /usr/bin/env bash

git clone git@github.com:dalehenrich/superDoit.git -b v4.1
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