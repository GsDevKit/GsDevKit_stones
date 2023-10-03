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
	# GSDEVKIT_STONES_ROOT defined in ci.yml
	export urlType=https
else
	# GSDEVKIT_STONES_ROOT is $STONES_HOME/test_git
	export GSDEVKIT_STONES_ROOT=$STONES_HOME/test_git/GsDevKit_stones
fi

set +e
defaultRegistryName=`hostname`
echo "...ignore registryReport.solo error message, if one shows up ... error is anticipated part of registryReport.solo processing"
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
	echo "reuse $STONES_HOME/test_gemstone for now"
	# chmod -R +w $STONES_HOME/test_gemstone *
	# rm -rf  $STONES_HOME/test_gemstone/*
fi
registerProductDirectory.solo --productDirectory=$STONES_HOME/test_gemstone $*
# download $GS_VERS
downloadGemStone.solo $GS_VERS $*
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

# create a $GS_VERS Rowan stone and install GsDevKit_home
createStone.solo --template=minimal_rowan gs_rowan $GS_VERS $*

echo $PLATFORM
set -x
if [ "$CI" = "true" ]; then
	# possible native code generation issues on mac and github, disable native code
	echo "NATIVE CODE*************************************"
	cat $STONES_HOME/test_stones/stones/gs_rowan/gem.conf
	if [[ "$PLATFORM" = "macos"* ]]; then
		cat - >> $STONES_HOME/test_stones/stones/gs_rowan/gem.conf << EOF
GEM_NATIVE_CODE_ENABLED=0;
EOF
	fi
	cat $STONES_HOME/test_stones/stones/gs_rowan/gem.conf
	echo "NATIVE CODE*************************************"
fi
set +x

#start stone
startStone.solo gs_rowan $*

# Add ROWAN_PROJECTS_HOME env var to point to the git directory where git repositories
#  used by this stone reside
# restart netldi, so env var available to JadeiteForPharo
export ROWAN_PROJECTS_HOME=$STONES_HOME/test_git
updateCustomEnv.solo  gs_rowan --addKey=ROWAN_PROJECTS_HOME --value=$ROWAN_PROJECTS_HOME --restart $*

gslist.solo -l

cd $STONES_HOME/test_stones/stones/gs_rowan

# install GsDevKit_stones using Rowan installProject.stone script
bin/installProject.stone file:$GSDEVKIT_STONES_ROOT/rowan/specs/GsDevKit_stones.ston \
  --projectsHome=$GSDEVKIT_STONES_ROOT/.. $*

# delete the stone
cd $STONES_HOME
deleteStone.solo gs_rowan $*
gslist.solo -l

