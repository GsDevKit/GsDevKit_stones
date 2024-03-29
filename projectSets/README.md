## Install superDoit and GsDevKit_stones

``` bash
# create a root directory where the stones and git repository directories that 
#   you create will be located ... using STONES_HOME for convenience
mkdir /home/dhenrich/_stones
cd /home/dhenrich/_stones
export STONES_HOME=`pwd`

# create a git repository for superDoit and GsDevKit_stones since they must be
#  installed before they can be used.
mkdir git
cd git

# clone and install superDoit
git clone git@github.com:dalehenrich/superDoit.git
cd superDoit
git checkout v4.1
cd bin
./install.sh
cd ../..

# clone GsDevKit_stones
git clone git@github.com:GsDevKit/GsDevKit_stones.git
cd GsDevKit_stones
git checkout v1.1.1
cd ..

```
## Add superDoit/bin and GsDevKit_stones/bin to your path
```bash
export PATH=$STONES_HOME/git/superDoit/bin:$STONES_HOME/git/GsDevKit_stones/bin:$PATH
versionReport.solo
export STONES_DATA_HOME=$XDG_DATA_HOME
if [ "$STONES_DATA_HOME" = "" ] ; then
	# on Mac ensure the directory you choose exists
	export STONES_DATA_HOME=$HOME/.local/share
fi
```

## Create a registry called \_stones for managing the superDoit and GsDevKit_stones repositories in $STONES_HOME/git
``` bash
cd $STONES_HOME

# create registry
createRegistry.solo _stones

# create project set using existing template: _stones
createProjectSet.solo --registry=_stones --projectSet=_stones \
  --from=$STONES_HOME/git/GsDevKit_stones/projectSets/ssh/_stones.ston

# use cloneProjectsFromProjectSet.solo to update the projects to match the specification in _stones.ston
cloneProjectsFromProjectSet.solo --registry=_stones --projectSet=_stones --projectDirectory=$STONES_HOME/git --update

# create and register a product directory where GemStone product trees are kept.
# This product download directory will be shared by all registries
mkdir $STONES_HOME/gemstone
registerProductDirectory.solo --registry=_stones --productDirectory=$STONES_HOME/gemstone
# download 3.7.0
downloadGemStone.solo --registry=_stones 3.7.0

# update product list from shared product directory when a download is done by shared registry
registerProduct.solo --registry=_stones --fromDirectory=$STONES_HOME/gemstone

# create and register default stones directory for rowanV3
mkdir $STONES_HOME/_stones
mkdir $STONES_HOME/_stones/stones
registerStonesDirectory.solo --registry=_stones \
                             --stonesDirectory=$STONES_HOME/_stones/stones

# create a 3.7.0 Rowan v2 stone
createStone.solo --template=minimal_rowan --start gs_370 3.7.0

# Add ROWAN_PROJECTS_HOME env var to customenv for stone.
#  ROWAN_PROJECTS_HOME points to the git directory where git repositories
#  used by this stone reside
# restart netldi, so env var available to JadeiteForDolphin
#
export ROWAN_PROJECTS_HOME=$STONES_HOME/test_git
updateCustomEnv.solo  gs_370 --addKey=ROWAN_PROJECTS_HOME --value=$ROWAN_PROJECTS_HOME --restart


# install GsDevKit_stones using Rowan installProject.stone script
cd _stones/stones/gs_370
bin/installProject.stone file:$ROWAN_PROJECTS_HOME/GsDevKit_stones/rowan/specs/GsDevKit_stones.ston \
  --projectsHome=$ROWAN_PROJECTS_HOME

```

## Create registry called rowanV3 and set up a Rowan v3 development environment
```bash
# create registry
createRegistry.solo rowanV3

# register the shared product directory
registerProductDirectory.solo --registry=rowanV3 --productDirectory=$STONES_HOME/gemstone
# update product list from shared product directory (since 3.7.0 is already downloaded)
registerProduct.solo --registry=rowanV3 --fromDirectory=$STONES_HOME/gemstone

# download 3.7.0_rowanv3-Alpha1
downloadGemStone.solo --registry=rowanV3 3.7.0 370_rowanv3-Alpha1

# create directory structure for rowanV3-specific artifacts: projects and stones
mkdir $STONES_HOME/rowanV3

# create project sets using existing templates: rowanV3_common, rowanV3_gs, and rowanV3_pharo
createProjectSet.solo --registry=rowanV3 --projectSet=rowanV3_common \
  --from=$STONES_HOME/git/GsDevKit_stones/projectSets/ssh/rowanV3_common.ston
createProjectSet.solo --registry=rowanV3 --projectSet=rowanV3_gs \
  --from=$STONES_HOME/git/GsDevKit_stones/projectSets/ssh/rowanV3_gs.ston
createProjectSet.solo --registry=rowanV3 --projectSet=rowanV3_pharo \
  --from=$STONES_HOME/git/GsDevKit_stones/projectSets/ssh/rowanV3_pharo.ston

# There are three project sets involved, because different versions of the same projects may
#    be required by GemStone and Pharo:
#
#  - rowanV3_common projects are used by both JadeiteForPharo and Gemstone
#  - rowanV3_gs projects are used by GemStone
#  - rowanV3_pharo projects are usd by JadeiteForPharo
#
# If you are using JadeiteForDolphin, then the rowanV3_pharo projects do not need to be 
#  cloned.
#
# cloneProjectsFromProjectSet.solo will create the project directory if it does not already exist
#
cloneProjectsFromProjectSet.solo --registry=rowanV3 --projectSet=rowanV3_common \
  --projectDirectory=$STONES_HOME/rowanV3/common_projects
cloneProjectsFromProjectSet.solo --registry=rowanV3 --projectSet=rowanV3_gs \
  --projectDirectory=$STONES_HOME/rowanV3/gs_projects
cloneProjectsFromProjectSet.solo --registry=rowanV3 --projectSet=rowanV3_pharo \
  --projectDirectory=$STONES_HOME/rowanV3/pharo_projects

# create and register default stones directory for rowanV3
mkdir $STONES_HOME/rowanV3/stones
registerStonesDirectory.solo --registry=rowanV3 \
                             --stonesDirectory=$STONES_HOME/rowanV3/stones

# create a Rowan v3 stone
createStone.solo --registry=rowanV3 --template=minimal_rowan --start rowanv3_370 370_rowanv3-Alpha1

# run set up scripts against the rowanv3_370 stone:
#   attachRowanDevClones.stone script attaches the Rowan, RowanClientServices, STON, and Cypress git
#     projects in $STONES_HOME/rowanV3/gs_projects to the image and reloads the projects from disk
cd $STONES_HOME/rowanV3/stones/rowanv3_370
bin/attachRowanDevClones.stone --projectsHome=$STONES_HOME/rowanV3/gs_projects
#   installProject.stone installs a project into the stone ... here, we'll install GsDevKit_stones 
#     and GsCommands as examples
bin/installProject.stone file:$STONES_HOME/git/GsDevKit_stones/rowan/specs/GsDevKit_stones.ston \
  --projectsHome=$STONES_HOME/git
bin/installProject.stone file:product/examples/GsCommands/projectsHome/GsCommands/rowan/specs/GsCommands.ston \
  --projectsHome=product/examples/GsCommands/projectsHome
# Add EXTERNALS_ST_BASE env var to customenv and restart netldi
updateCustomEnv.solo --registry=rowanV3 rowanv3_370 \
  --addKey=EXTERNALS_ST_BASE --value=$STONES_HOME/git --restart
```
