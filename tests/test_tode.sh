#! /usr/bin/env bash
#
# test coverage for setting up a rowan v3 alpha dev environment
#		registryReport.sol
#		createRegistry.solo
#		createProjectSet.solo
#		updateProjectSet.solo
#		cloneProjectsFromProjectSet.solo
#		
set -xe

echo "***** test_tode.sh *****"

if [ ! -d $STONES_HOME/test_git ]; then
	mkdir $STONES_HOME/test_git
else
	rm -rf  $STONES_HOME/test_git/*
fi

if [ "$CI" != "true" ]; then
	if [ "$GS_VERS"x = "x" ] ; then
		export GS_VERS=3.7.0
	fi
fi

registry=devkit
projectSet=devkit
todeHome="$STONES_HOME/$registry/tode"

export urlType=ssh
if [ "$CI" = "true" ]; then
	# GSDEVKIT_STONES_ROOT defined in ci.yml
	export urlType=https
else
	# GSDEVKIT_STONES_ROOT is $STONES_HOME/git ... the location that GsDevKit_stones 
	#	was cloned when superDoit was installed
	export GSDEVKIT_STONES_ROOT=$STONES_HOME/git/GsDevKit_stones
fi

createRegistry.solo $registry --ensure

if [ -d $STONES_HOME/devKit/ ]; then
	rm -rf  $STONES_HOME/$registry/devKit
fi

createProjectSet.solo --registry=$registry --projectSet=$projectSet \
  --from=$GSDEVKIT_STONES_ROOT/projectSets/$urlType/devkit.ston $*

registerProjectDirectory.solo --registry=$registry --projectDirectory=$STONES_HOME/$registry/devkit $*

# cloneProjectsFromProjectSet.solo will create the project directory if it does not already exist
cloneProjectsFromProjectSet.solo --registry=$registry --projectSet=$projectSet $*


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
	mkdir $STONES_HOME/$registry/stones
else
	rm -rf $STONES_HOME/$registry/stones
	mkdir $STONES_HOME/$registry/stones
fi

registerStonesDirectory.solo --registry=$registry --stonesDirectory=$STONES_HOME/$registry/stones $*

if [ ! -d $todeHome ]; then
	mkdir $todeHome
else
	rm -rf $todeHome/*
fi

registerTodeSharedDir.solo --registry=$registry \
                           --todeHome=$todeHome \
                           --populate
template="default_tode"

# create a $GS_VERS stone
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

#start stone
startStone.solo --registry=$registry $stoneName -b $*

gslist.solo -l

# install tODE
cd $STONES_HOME/$registry/stones/$stoneName
loadTode.stone --projectDirectory=$STONES_HOME/$registry/devkit $*

#
# skip todieIt.solo and setUpSys_1 and setUpSys_2 ... not required and todeIt.stone should be used instead
#
# validate installation by running a couple of todeIt.stone commands
todeIt.stone -h
todeIt.stone 'eval `3+4`' $*

 cat - > testing << EOF
eval \`TDTestToolTests enableTests: false\`
test --batch class TDTestToolTests
eval \`self hasFailures ifTrue: [ self error: 'FAILING' ] ifFalse: [ self ]\`
EOF
todeIt.stone --file=testing $*

# install seaside
metacelloLoad.stone --project=Seaside3 --repoPath=repository \
	--projectDirectory=$STONES_HOME/$registry/devkit/Seaside \
	Welcome Development 'Zinc Project' Examples CI $*

if [ "1" = "0" ]; then
set +e
# run Seaside unit tests ... expect some failures, like WAWebDriverFunctionalTestCases and a few others
#--transcript--'**************************************************************************************'
#--transcript--'Results for Seaside3 tests'
#--transcript--'1525 run, 1481 passes, 4 expected defects, 0 failures, 40 errors, 0 unexpected passes'
#--transcript--'**************************************************************************************'
cat - > testing << EOF
test --batch project Seaside3
eval \`self hasFailures ifTrue: [ self error: 'FAILING' ] ifFalse: [ self ]\`
EOF
todeIt.stone --file=testing $*
set -e
fi

# delete the stone
cd $STONES_HOME
deleteStone.solo -r $registry $stoneName $*
gslist.solo -l

