#! /usr/bin/env bash

set -e

if [ ! -d $STONES_HOME/test_git ]; then
	mkdir $STONES_HOME/test_git
else
	rm -rf  $STONES_HOME/test_git/*
fi
registry=test
projectSet=xxx
export urlType=ssh
if [ "$CI" = "true" ]; then
	export urlType=https
fi

set +e
registryReport.solo --registry=$registry
status=$?
set -e

if [ $status == 1 ]; then
	echo "creating $registry registry"
	createRegistry.solo $registry
else
	echo "registry $registry exists"
fi

TEST_SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
$TEST_SCRIPTS_DIR/createTestProjectSet.sh $*

cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet \
 	--projectDirectory=$STONES_HOME/test_git $*

# use --update, which will do a pull
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet \
	--projectDirectory=$STONES_HOME/test_git --remote=gs --update $*

# use --update, which will do a pull ... second time (branch already exists)
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet \
	--projectDirectory=$STONES_HOME/test_git --remote=gs --update $*
