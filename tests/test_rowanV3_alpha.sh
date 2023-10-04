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

registry=test_rowanV3
projectSet_common=rowanV3_common
projectSet_gs=rowanV3_gs
projectSet_pharo=rowanV3_pharo

export urlType=ssh
if [ "$CI" = "true" ]; then
	# GSDEVKIT_STONES_ROOT defined in ci.yml
	export urlType=https
else
	# GSDEVKIT_STONES_ROOT is $STONES_HOME/git ... the location that GsDevKit_stones 
	#	was cloned when superDoit was installed
	export GSDEVKIT_STONES_ROOT=$STONES_HOME/git/GsDevKit_stones
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

# cloneProjectsFromProjectSet.solo will create the project directory if it does not already exist
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=rowanV3_common \
  --projectDirectory=$STONES_HOME/$registry/common_projects
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=rowanV3_gs \
  --projectDirectory=$STONES_HOME/$registry/gs_projects
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=rowanV3_pharo \
  --projectDirectory=$STONES_HOME/$registry/pharo_projects

# create and register a product directory where GemStone product trees are kept.
if [ ! -d $STONES_HOME/test_gemstone ]; then
	mkdir $STONES_HOME/test_gemstone
else
	echo "reuse $STONES_HOME/test_gemstone for now"
	# chmod -R +w $STONES_HOME/test_gemstone *
	# rm -rf  $STONES_HOME/test_gemstone/*
fi
registerProductDirectory.solo --registry=$registry --productDirectory=$STONES_HOME/test_gemstone $*
# download $GS_VERS
downloadGemStone.solo --registry=$registry 3.7.0 $GS_VERS $*
# update product list from shared product directory when a download is done by shared registry
registerProduct.solo --registry=$registry --fromDirectory=$STONES_HOME/test_gemstone $*

# create and register stones directory for test_rowanV3
if [ ! -d $STONES_HOME/$registry/stones ]; then
	mkdir $STONES_HOME
	# attach stone to the Rowan projects that are part of the base image/test_rowanV3
	mkdir $STONES_HOME/$registry/stones
else
	rm -rf  $STONES_HOME/$registry/*
	mkdir $STONES_HOME/$registry/stones
fi

registerStonesDirectory.solo --registry=$registry --stonesDirectory=$STONES_HOME/$registry/stones $*

template="minimal_rowan"

# create a $GS_VERS Rowan stone and install GsDevKit_home
export stoneName=gs_$GS_VERS
createStone.solo --registry=$registry --template=$template $stoneName $GS_VERS $*

echo $PLATFORM
set -x
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
set +x

#start stone
startStone.solo --registry=$registry $stoneName $*

# Add ROWAN_PROJECTS_HOME env var to point to the git directory where git repositories
#  used by this stone -
# restart netldi, so env var available to JadeiteForPharo
export ROWAN_PROJECTS_HOME=$STONES_HOME/test_git
updateCustomEnv.solo --registry=$registry $stoneName --addKey=ROWAN_PROJECTS_HOME --value=$ROWAN_PROJECTS_HOME --restart $*

gslist.solo -l

if [ "$template" = "minimal_rowan" ] ; then
	cd $STONES_HOME/$registry/stones/$stoneName

	# attach stone to the Rowan projects that are part of the base image
	bin/attachRowanDevClones.stone --projectsHome=$STONES_HOME/$registry/gs_projects
	# install GsDevKit_stones using Rowan installProject.stone script
	bin/installProject.stone file:$GSDEVKIT_STONES_ROOT/rowan/specs/GsDevKit_stones.ston \
  	--projectsHome=$GSDEVKIT_STONES_ROOT/.. $*
	bin/installProject.stone file:product/examples/GsCommands/projectsHome/GsCommands/rowan/specs/GsCommands.ston \
  --projectsHome=product/examples/GsCommands/projectsHome
	bin/installProject.stone file:$STONES_HOME/rowanV3_common/RemoteServiceReplication/rowan/specs/RemoteServiceReplication.ston  --projectsHome=$STONES_HOME/rowanV3_common
	bin/installProject.stone file:$STONES_HOME/rowanV3_gs/RowanClientServices/rowan/specs/RowanClientServices.ston  --projectsHome=$STONES_HOME/rowanV3_gs
fi

# delete the stone
cd $STONES_HOME
deleteStone.solo $stoneName $*
gslist.solo -l

