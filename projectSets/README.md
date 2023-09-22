## Install superDoit and GsDevKit_stones

``` bash
mkdir /home/dhenrich/_stones
cd /home/dhenrich/_stones
export STONES_HOME=`pwd`

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

## Create a Rowan v3 development environment

``` bash
cd $STONES_HOME

# create a Rowan v3 development environment: 
#  1. git repositories with required GitHub projects
#  2. a Rowan v3 development stone
#  3. a Pharo11 image with JadeiteForPharo installed

# create a directory where the git projects and stones will reside
cd $STONES_HOME
mkdir rowanV3
cd rowanV3
# common_projects is the directory that contains the git projects that are
# shared between the Rowan v3 stone and the JadeitForPharo image
#
# gs_projects is the directory that contains the git projects that are specific 
# to GemStone
#
# pharo_projects is the directory that contains the git projects that are specific
# to Pharo
mkdir common_projects projects gs_projects pharo_projects stones

# The following commands clone the git projects into each of the 3 directories 
cloneProjectsFromProjectSet.solo --registry=rogue --projectSet=rowanV3_common --projectDirectory=$STONES_HOME/rowanV3/common_projects
cloneProjectsFromProjectSet.solo --registry=rogue --projectSet=rowanV3_gs --projectDirectory=$STONES_HOME/rowanV3/gs_projects
cloneProjectsFromProjectSet.solo --registry=rogue --projectSet=rowanV3_pharo --projectDirectory=$STONES_HOME/rowanV3/pharo_projects

```
### Rowan v3 git repositories
### Jadeit for Pharo
### Rowan v3 stones
