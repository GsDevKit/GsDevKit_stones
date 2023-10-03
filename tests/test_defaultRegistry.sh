#! /usr/bin/env bash
#
# test coverage for when --registry option is omitted (default registry name will be hostname):
#		registryReport.sol
#		createRegistry.solo
#		createProjectSet.solo
#		updateProjectSet.solo
#		cloneProjectsFromProjectSet.solo
#		
set -e

echo "***** test_defaultRegistry.sh *****"

if [ ! -d $STONES_HOME/test_git ]; then
	mkdir $STONES_HOME/test_git
else
	rm -rf  $STONES_HOME/test_git/*
fi
projectSet=xxx
export urlType=ssh
if [ "$CI" = "true" ]; then
	export urlType=https
fi

set +e
defaultRegistryName=`hostname`
registryReport.solo --registry=`hostname`
status=$?
set -e

if [ $status == 1 ]; then
	echo "creating default registry"
	createRegistry.solo
else
	echo "default registry ($defaultRegistryName) exists"
fi

createProjectSet.solo --projectSet=$projectSet --empty $*

# in github actions, we must use https urls, since we don't have ssh credentials 
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

# add origin and gs remotes for the project
updateProjectSet.solo --projectSet=$projectSet \
		--projectName=$theProjectName \
		--gitUrl=$url1\
		--remote=origin \
		--revision=$revision $*

updateProjectSet.solo --projectSet=$projectSet \
		--projectName=$theProjectName \
		--gitUrl=$url2 \
		--remote=gs \
		--revision=$revision  $*

# clone the projects to the test_git repository
cloneProjectsFromProjectSet.solo --projectSet=$projectSet \
 	--projectDirectory=$STONES_HOME/test_git $*

# create and register a product directory where GemStone product trees are kept.
if [ ! -d $STONES_HOME/test_gemstone ]; then
	mkdir $STONES_HOME/test_gemstone
else
	chmod -R +w $STONES_HOME/test_gemstone *
	rm -rf  $STONES_HOME/test_gemstone/*
fi
registerProductDirectory.solo --productDirectory=$STONES_HOME/test_gemstone $*
# download 3.7.0
downloadGemStone.solo 3.7.0 $*
# update product list from shared product directory when a download is done by shared registry
registerProduct.solo --fromDirectory=$STONES_HOME/test_gemstone $*

# create and register default stones directory for rowanV3
if [ ! -d $STONES_HOME/test_stones ]; then
	mkdir $STONES_HOME/test_stones
	mkdir $STONES_HOME/test_stones/stones
else
	rm -rf  $STONES_HOME/test_stones/*
	mkdir $STONES_HOME/test_stones/stones
fi

registerStonesDirectory.solo --stonesDirectory=$STONES_HOME/test_stones/stones $*

