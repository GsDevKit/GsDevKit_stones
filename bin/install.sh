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
pushd superDoit/bin
./install.sh
popd

PATH=`pwd`/superDoit/bin:`pwd`/GsDevKit_stones/bin:$PATH
GSDEVKIT_STONES_ROOT=`pwd`/GsDevKit_stones
STONES_DATA_HOME=$XDG_DATA_HOME
if [ "$STONES_DATA_HOME" = "" ] ; then
	# on Mac ensure the directory you choose exists
	export STONES_DATA_HOME=$HOME/.local/share
fi
versionReport.solo

set +x
echo "====================================================================="
echo "Add the following to your shell startup config and restart your shell"
echo "====================================================================="
echo "#GsDevKit_stones"
echo "export PATH=`pwd`/superDoit/bin:`pwd`/GsDevKit_stones/bin:\$PATH"
echo "export GSDEVKIT_STONES_ROOT=`pwd`/GsDevKit_stones"
echo "export STONES_DATA_HOME=\$XDG_DATA_HOME"
echo "if [ \"\$STONES_DATA_HOME\" = \"\" ] ; then"
echo "	# on Mac ensure the directory you choose exists"
echo "	export STONES_DATA_HOME=\$HOME/.local/share"
echo "fi"