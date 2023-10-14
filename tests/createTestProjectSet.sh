#! /usr/bin/env bash
#
# test coverage for:
#		registryReport.sol
#		createRegistry.solo
#		createProjectSet.solo
#		updateProjectSet.solo

set -e

registry=test
projectSet=xxx

if [ ! -d $STONES_HOME/test_git ]; then
	mkdir $STONES_HOME/test_git
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

set +e
createProjectSet.solo --registry=$registry --projectSet=$projectSet --empty $*
status=$?

if [ $status == 1 ]; then
	echo "project set $projectSet exists"
fi

if [ "$urlType" = "ssh" ] ; then
	url1="git@github.com:GsDevKit/GsDevKit_stones.git"
	url2="git@git.gemtalksystems.com:GsDevKit_stones"
	revision="v1.1.1"
	theProjectName=GsDevKit_stones
else
	url1="https://github.com/GsDevKit/Seaside31.git"
	url2="https://github.com/glassdb/Seaside31.git"
	revision=master
 theProjectName=Seaside31
fi

updateProjectSet.solo --registry=$registry --projectSet=$projectSet \
		--projectName=$theProjectName \
		--gitUrl=$url1\
		--remote=origin \
		--revision=$revision $*

updateProjectSet.solo --registry=$registry --projectSet=$projectSet \
		--projectName=$theProjectName \
		--gitUrl=$url2 \
		--remote=gs \
		--revision=$revision  $*


