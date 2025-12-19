#! /usr/bin/env bash
#
# .../GsDevKit_stones/tests/testRowanV3.sh -D >> test_rowanV3.out 2>&1
# test coverage for setting up a rowan v3 dev environment
#		registryReport.solo
#		createRegistry.solo
#		createProjectSet.solo
#		updateProjectSet.solo
#		cloneProjectsFromProjectSet.solo
#		backupStone.stone
#		
set -e
set -x

echo "***** test_rowanV3.sh *****"

if [ ! -d $STONES_HOME/test_git ]; then
	mkdir $STONES_HOME/test_git
else
	rm -rf  $STONES_HOME/test_git/*
fi

if [ "$GS_VERS"x = "x" ] ; then
	export GS_VERS=3.7.4.3
elif	[ "$GS_VERS" != "3.7.4.3" ]; then
	echo "skip test_rowanV3.sh for $GS_VERS ... only 3.7.2 or later should be supported"
	exit 0
fi

export stoneName=test_rowanv3_3743

registry=test_rowanV3
projectSet_common=rowan_V3_common
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
	export urlType=ssh
fi

createRegistry.solo $registry --ensure

createProjectSet.solo --registry=$registry --projectSet=$projectSet_common \
  --from=$GSDEVKIT_STONES_ROOT/projectSets/$urlType/rowanV3_common.ston $*
createProjectSet.solo --registry=$registry --projectSet=$projectSet_gs \
  --from=$GSDEVKIT_STONES_ROOT/projectSets/$urlType/rowanV3_gs.ston $*
createProjectSet.solo --registry=$registry --projectSet=$projectSet_pharo \
  --from=$GSDEVKIT_STONES_ROOT/projectSets/$urlType/rowanV3_pharo.ston $*

if [ -d $STONES_HOME/$registry/same_host_projects ]; then
	rm -rf  $STONES_HOME/$registry/same_host_projects
fi
if [ -d $STONES_HOME/$registry/gs_host_projects ]; then
	rm -rf  $STONES_HOME/$registry/gs_host_projects
fi
if [ -d $STONES_HOME/$registry/pharo_host_projects ]; then
	rm -rf  $STONES_HOME/$registry/pharo_host_projects
fi

# cloneProjectsFromProjectSet.solo will create the project directory if it does not already exist
#
# scenario 1 ... Pharo and GemStone on same host ... all projects cloned into a common directory
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet_gs \
  --projectDirectory=$STONES_HOME/$registry/same_host_projects $*
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet_common \
  --projectDirectory=$STONES_HOME/$registry/same_host_projects $*
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet_pharo \
  --projectDirectory=$STONES_HOME/$registry/same_host_projects $*
#
# scenario 2 ... Pharo and GemStone on separate hosts ... gs and pharo directories
#
# gs_host_projects
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet_gs \
  --projectDirectory=$STONES_HOME/$registry/gs_host_projects $*
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet_common \
  --projectDirectory=$STONES_HOME/$registry/gs_host_projects $*
#
# pharo_host_projects
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet_common \
  --projectDirectory=$STONES_HOME/$registry/pharo_host_projects $*
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet_pharo \
  --projectDirectory=$STONES_HOME/$registry/pharo_host_projects $*

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
downloadGemStone.solo --registry=$registry 3.7.4.3 $*
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

template="minimal_rowan3"

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
startNetldi.solo --registry=$registry $stoneName

# run glist.solo for record of running stone and netldi
gslist.solo -l

if [ "$template" = "minimal_rowan3" ] ; then
	cd $STONES_HOME/$registry/stones/$stoneName
		
	backupStone.stone --wait test_backup_2.dbf --compressed --safely --validate

	# turn on unicodeComparisonMode required by Jadeite
	enableUnicodeCompares.topaz -lq
	echo "installing GsCommands"
	installProject.stone file:product/examples/GsCommands/projectsHome/GsCommands/rowan/specs/GsCommands.ston \
    --projectsHome=product/examples/GsCommands/projectsHome $*

	if [ "$urlType" = "ssh" ] ; then
		# RemoteServiceReplication requires Announcements and is defined to use ssh clone
		echo "installing RemoteServiceReplication -- partial workaround for https://github.com/GemTalk/Rowan/issues/905"
		installProject.stone file:$STONES_HOME/$registry/gs_host_projects/RemoteServiceReplication/rowan/specs/RemoteServiceReplication.ston  \
			--projectsHome=$STONES_HOME/$registry/gs_host_projects $*
	fi

	echo "installing RowanClientServices"
	installProject.stone file:$STONES_HOME/$registry/gs_host_projects/RowanClientServicesV3/rowan/specs/RowanClientServices.ston  \
		--alias=RowanClientServicesV3 \
		--projectsHome=$STONES_HOME/$registry/gs_host_projects $*

	# attach stone to the Rowan projects that are part of the base image
	attachRowanDevClones.stone --projectsHome=$STONES_HOME/$registry/same_host_projects $*

	# install GsDevKit_stones using Rowan installProject.stone script
	echo "installing GsDevKit_stones"
	installProject.stone file:$GSDEVKIT_STONES_ROOT/rowan/specs/GsDevKit_stones.ston \
 		--projectsHome=$GSDEVKIT_STONES_ROOT/.. $*
fi

# delete the stone
#cd $STONES_HOME
#deleteStone.solo -r $registry $stoneName $*
#gslist.solo -l

