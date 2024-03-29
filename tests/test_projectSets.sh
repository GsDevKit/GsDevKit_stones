#! /usr/bin/env bash
#
# test coverage for:
#		registryReport.sol
#		createRegistry.solo
#		updateProjectSet.solo
#		cloneProjectsFromProjectSet.solo
#		
set -e

echo "***** test_projectSets.sh *****"

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

createRegistry.solo $registry --ensure

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
