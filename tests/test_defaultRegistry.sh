#! /usr/bin/env bash
#
# test coverage for when --registry option is omitted (default registry name will be hostname):
#		registryReport.sol
#		registryQuery.solo
#		createRegistry.solo
#		createProjectSet.solo
#		updateProjectSet.solo
#		cloneProjectsFromProjectSet.solo
#		
set -e
# set -x

echo "***** test_defaultRegistry.sh *****"

if [ ! -d $STONES_HOME/test_git ]; then
	mkdir $STONES_HOME/test_git
else
	rm -rf  $STONES_HOME/test_git/*
fi

if [ "$GS_VERS"x = "x" ]; then
	export GS_VERS=3.7.0
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

defaultRegistryName=`hostname`

createRegistry.solo --ensure

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

productPath=`registryQuery.solo --product=$GS_VERS`
echo "product path for ${GS_VERS}: $productPath"
# create and register default stones directory for rowanV3
if [ ! -d $STONES_HOME/test_stones ]; then
	mkdir $STONES_HOME/test_stones
	mkdir $STONES_HOME/test_stones/stones
else
	rm -rf  $STONES_HOME/test_stones/*
	mkdir $STONES_HOME/test_stones/stones
fi

registerStonesDirectory.solo --stonesDirectory=$STONES_HOME/test_stones/stones $*

case "$GS_VERS" in
   3.7.*|3.6.[4-9])
		template="minimal_rowan"
		;;
   3.5.[3-8]|3.6.[0-3])
		template="minimal"
    ;;
	 3.4.*|3.5.[0-2])
		if [ "$CI" = "true" ] ; then
			echo "only GemStone version 3.5.3 and older may be used on GitHub (Ubuntu 20.04)"
			exit 1
		else
			template="minimal"
		fi
    ;;
esac
# create a $GS_VERS Rowan stone and install GsDevKit_home
export stoneName=gs_$GS_VERS
createStone.solo --template=$template $stoneName $GS_VERS $*

echo $PLATFORM

if [ "$CI" = "true" ]; then
	# possible native code generation issues on mac and github, disable native code
	echo "NATIVE CODE*************************************"
	cat $STONES_HOME/test_stones/stones/$stoneName/gem.conf
	if [[ "$PLATFORM" = "macos"* ]]; then
		cat - >> $STONES_HOME/test_stones/stones/$stoneName/gem.conf << EOF
GEM_NATIVE_CODE_ENABLED=0;
EOF
	fi
	cat $STONES_HOME/test_stones/stones/$stoneName/gem.conf
	echo "NATIVE CODE*************************************"
fi

#start stone
startStone.solo $stoneName $*

pushd $STONES_HOME/test_stones/stones
	# test snapshot.stone -- snapshot.stone must be run in the stone directory
	#   this script is expected to be run in non-Rowan extents and cannot load
	#   the GsDevKit_stones support code (right now)
	if [ ! -d "snapshots" ]; then
		mkdir snapshots
	fi
	snapshot.stone --extension=`date +%m-%d-%Y_%H:%M:%S`.dbf snapshots --safely $*
popd
# should remove the requirement for -r ...
newExtent.solo -r $defaultRegistryName -e snapshots/*.dbf $stoneName $*

# Add ROWAN_PROJECTS_HOME env var to point to the git directory where git repositories
#  used by this stone reside
# restart netldi, so env var available to JadeiteForPharo
export ROWAN_PROJECTS_HOME=$STONES_HOME/test_git
updateCustomEnv.solo  $stoneName --addKey=ROWAN_PROJECTS_HOME --value=$ROWAN_PROJECTS_HOME --restart $*

gslist.solo -l

if [ "$template" = "minimal_rowan" ] ; then
	cd $STONES_HOME/test_stones/stones/$stoneName

	# install GsDevKit_stones using Rowan installProject.stone script
	bin/installProject.stone file:$GSDEVKIT_STONES_ROOT/rowan/specs/GsDevKit_stones.ston \
  	--projectsHome=$GSDEVKIT_STONES_ROOT/.. $*
fi

# delete the stone
cd $STONES_HOME
deleteStone.solo $stoneName $*
gslist.solo -l

