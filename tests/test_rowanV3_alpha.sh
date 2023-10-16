#! /usr/bin/env bash
#
# test coverage for setting up a rowan v3 alpha dev environment
#		registryReport.sol
#		createRegistry.solo
#		createProjectSet.solo
#		updateProjectSet.solo
#		cloneProjectsFromProjectSet.solo
#		
set -e

echo "***** test_rowanV3_alpha.sh *****"

if [ ! -d $STONES_HOME/test_git ]; then
	mkdir $STONES_HOME/test_git
else
	rm -rf  $STONES_HOME/test_git/*
fi

export GS_VERS=370_rowanv3-Alpha1
export stoneName=rowanv3_370

registry=test_rowanV3
projectSet_common=rowanV3_common
projectSet_gs=rowanV3_gs
projectSet_pharo=rowanV3_pharo

export urlType=ssh
if [ "$CI" = "true" ]; then
	# GSDEVKIT_STONES_ROOT defined in ci.yml
	# https has to be used on github, because default ssh
	#  credentials are not setup 
	export urlType=https
else
	# GSDEVKIT_STONES_ROOT is $STONES_HOME/git ... the location that GsDevKit_stones 
	#	was cloned when superDoit was installed
	export GSDEVKIT_STONES_ROOT=$STONES_HOME/git/GsDevKit_stones
	set +e
	ping -c 1 git.gemtalksystems.com
	status=$?
	set -e
	if [ $status = 0 ]; then
		# in a GemStone development environment, so use the gs project sets
		# which include the internal remotes (gs) using git.gemtalksystems.com
		export urlType=gs
	fi
fi

set +e
echo "...ignore registryReport.solo error message, if one shows up ... error is anticipated part of registryReport.solo processing"
registryReport.solo --registry=$registry
status=$?
set -e

if [ $status == 1 ]; then
	echo "creating $registry registry"
	createRegistry.solo $registry
else
	echo "registry ($registry) exists"
fi

createProjectSet.solo --registry=$registry --projectSet=$projectSet_common \
  --from=$GSDEVKIT_STONES_ROOT/projectSets/$urlType/rowanV3_common.ston $*
createProjectSet.solo --registry=$registry --projectSet=$projectSet_gs \
  --from=$GSDEVKIT_STONES_ROOT/projectSets/$urlType/rowanV3_gs.ston $*
createProjectSet.solo --registry=$registry --projectSet=$projectSet_pharo \
  --from=$GSDEVKIT_STONES_ROOT/projectSets/$urlType/rowanV3_pharo.ston $*

if [ -d $STONES_HOME/$registry/common_projects ]; then
	rm -rf  $STONES_HOME/$registry/common_projects
fi
if [ -d $STONES_HOME/$registry/gs_projects ]; then
	rm -rf  $STONES_HOME/$registry/gs_projects
fi
if [ -d $STONES_HOME/$registry/pharo_projects ]; then
	rm -rf  $STONES_HOME/$registry/pharo_projects
fi

# cloneProjectsFromProjectSet.solo will create the project directory if it does not already exist
# read -p "Stop before first cloneProjectsFromProjectSet"
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet_common \
  --projectDirectory=$STONES_HOME/$registry/common_projects $*
# read -p "Stop before second cloneProjectsFromProjectSet"
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet_gs \
  --projectDirectory=$STONES_HOME/$registry/gs_projects $*
# read -p "Stop before third cloneProjectsFromProjectSet"
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet_pharo \
  --projectDirectory=$STONES_HOME/$registry/pharo_projects $*
# read -p "Stop after last cloneProjectsFromProjectSet"

# create and register a product directory where GemStone product trees are kept.
if [ ! -d $STONES_HOME/$registry/gemstone ]; then
	mkdir $STONES_HOME/$registry/gemstone
else
	echo "reuse $STONES_HOME/$registry/gemstone for now"
fi
registerProductDirectory.solo --registry=$registry --productDirectory=$STONES_HOME/$registry/gemstone $*
# reference the already downloaded product trees in $STONES_HOME/gemstone
registerProduct.solo -r $registry --fromDirectory=$STONES_HOME/gemstone

# download $GS_VERS
downloadGemStone.solo --registry=$registry 3.7.0 $GS_VERS $*
#
# populate the clientlibs directory with 64bit libraries for use by JfP
#
updateClientLibs.solo -r $registry $GS_VERS $*

# create and register stones directory for test_rowanV3
if [ ! -d $STONES_HOME/$registry/stones ]; then
	mkdir $STONES_HOME/$registry/stones
else
	rm -rf $STONES_HOME/$registry/stones
	mkdir $STONES_HOME/$registry/stones
fi

registerStonesDirectory.solo --registry=$registry --stonesDirectory=$STONES_HOME/$registry/stones $*

template="minimal_rowan"

# create a $GS_VERS Rowan stone and install GsDevKit_home
createStone.solo --registry=$registry --template=$template $stoneName $GS_VERS $*

echo $PLATFORM
if [ "$CI" = "true" ]; then
	# possible native code generation issues on mac and github, disable native code
	echo "NATIVE CODE*************************************"
	cat $STONES_HOME/$registry/stones/$stoneName/gem.conf
	if [[ "$PLATFORM" = "macos"* ]]; then
		cat - >> $STONES_HOME/$registry/stones/$stoneName/gem.conf << EOF
GEM_NATIVE_CODE_ENABLED=0;
EOF
	fi
	cat $STONES_HOME/$registry/stones/$stoneName/gem.conf
	echo "NATIVE CODE*************************************"
fi

#start stone
startStone.solo --registry=$registry $stoneName $*

# Add ROWAN_PROJECTS_HOME env var to point to the git directory where git repositories
#  used by this stone -
# restart netldi, so env var available to JadeiteForPharo
export ROWAN_PROJECTS_HOME=$STONES_HOME/test_git
updateCustomEnv.solo --registry=$registry $stoneName --addKey=ROWAN_PROJECTS_HOME --value=$ROWAN_PROJECTS_HOME --restart $*

# start netldi
startNetldi.solo --registry=$registry $stoneName $*

# run glist.solo for record of running stone and netldi
gslist.solo -l

if [ "$template" = "minimal_rowan" ] ; then
	cd $STONES_HOME/$registry/stones/$stoneName

	# turn on unicodeComparisonMode required by Jadeite
	enableUnicodeCompares.topaz -lq
	# install GsDevKit_stones using Rowan installProject.stone script
	echo "installing GsDevKit_stones"
	bin/installProject.stone file:$GSDEVKIT_STONES_ROOT/rowan/specs/GsDevKit_stones.ston \
  	--projectsHome=$GSDEVKIT_STONES_ROOT/.. $*
	echo "installing GsCommands"
	bin/installProject.stone file:product/examples/GsCommands/projectsHome/GsCommands/rowan/specs/GsCommands.ston \
    --projectsHome=product/examples/GsCommands/projectsHome $*

	echo "installing Announcements -- hack until we fix up reguired projects in RowanClientServices"
	$GSDEVKIT_STONES_ROOT/bin/installProject.stone file:$STONES_HOME/$registry/common_projects/Announcements/rowan/specs/Announcements.ston  \
		--projectsHome=$STONES_HOME/$registry/common_projects $*

	echo "installing RemoteServiceReplication -- partial workaround for https://github.com/GemTalk/Rowan/issues/905"
	$GSDEVKIT_STONES_ROOT/bin/installProject.stone file:$STONES_HOME/$registry/common_projects/RemoteServiceReplication/rowan/specs/RemoteServiceReplication.ston  \
		--projectsHome=$STONES_HOME/$registry/common_projects $*

	echo "installing RowanClientServices"
	bin/installProject.stone file:$STONES_HOME/$registry/gs_projects/RowanClientServices/rowan/specs/RowanClientServices.ston  \
		--projectsHome=$STONES_HOME/$registry/gs_projects $*

	# attach stone to the Rowan projects that are part of the base image
	bin/attachRowanDevClones.stone --projectsHome=$STONES_HOME/$registry/gs_projects $*
fi

# delete the stone
cd $STONES_HOME
deleteStone.solo -r $registry $stoneName $*
gslist.solo -l

