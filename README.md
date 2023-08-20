# GsDevKit_stones
Greatly simplified version of GsDevKit_home
1. bin directory of scripts implemented with superDoit and 3.6.5 for solo scripts and GsHostProcess ala the .solo battery test drivers used internally
2. stone directory modeled after GsDevKit_home, but configurable for folks with different needs … some sort of template for definition of directory structure
3. registry of stones so that stones can be located anywhere
4. standard location for git repos
5. if you are using tODE I think you should continue using GsDevKit_home

## Installation
``` bash
git clone git@github.com:GsDevKit/GsDevKit_stones.git
GsDevKit_stones/bin/install.sh

export PATH=`pwd`/superDoit/bin:`pwd`/GsDevKit_stones/bin:$PATH
versionReport.solo
export STONES_DATA_HOME=$XDG_DATA_HOME
if [ "$STONES_DATA_HOME" = "" ] ; then
	# on Mac ensure the directory you choose exists
	export STONES_DATA_HOME=$HOME/.local/share
fi
```

## STONES_DATA_HOME
GsDevKit_stones maintains a registry data structure based on the [XDG Base Directory Specification](https://xdgbasedirectoryspecification.com/). On Linux machines, the default location for application specific data is $HOME/.local/share and $XDG_DATA_HOME can be used to optionally define an alternate location. On Mac machines, the XDG Base Directory Specification is not defined. 

Therefore to simplify the coding and allow for the creation of short-leved registry structures, The environment variable STONES_DATA_HOME is used to define the root directory for GsDevKit_STONES applications. On Linux, STONES_DATA_HOME defaults to $HOME/.local/share. On Mac, STONES_DATA_HOME must be defined.

## Setting up the registry structure
```bash
registryName=`hostname`
projectSetName="devkit"
gemstoneProductsDirectory="/home/dhenrich/_stones/gemstone"
projectsDirectory="/home/dhenrich/_stones/git/"
stonesDirectory="/home/dhenrich/_stones/stones"
todeHome="/home/dhenrich/_stones/tode"
echo "
 registry:    $registryName
 project set: $projectSetName 
 products:    $gemstoneProductsDirectory
 projects:    $projectsDirectory 
 stones:      $stonesDirectory
 tode:        $todeHome"

createRegistry.solo $registryName
createProjectSet.solo --registry=$registryName --projectSet=$projectSetName --ssh
createProjectSet.solo --registry=$registryName --projectSet=${projectSetName}_https --https
cloneProjectsFromProjectSet.solo --registry=$registryName --projectSet=$projectSetName \
                                 --projectDirectory=$projectsDirectory
registerProductDirectory.solo --registry=$registryName \
                              --productDirectory=$gemstoneProductsDirectory

# GemStone version not previously downloaded
downloadGemStone.solo --registry=$registryName 3.6.6

# Register full set of previously downloaded product trees
registerProduct.solo --registry=$registryName \
                     --fromDirectory=$GS_HOME/shared/downloads/products
# register named GemStone version using path to product tree
registerProduct.solo --registry=$registryName \
                     --productPath=/bosch1/users/dhenrich/_work/d_37x/noop50/gs/product 3.7.0

# register default stones directory
registerStonesDirectory.solo --registry=$registryName \
                             --stonesDirectory=$stonesDirectory

# register shared tODE directory
registerTodeSharedDir.solo --registry=$registryName  \
                           --todeHome=$todeHome \
                           --populate

registryReport.solo
```

## Create stones
```bash
# create stone in default stones directory
createStone.solo --registry=$registryName --template=default_seaside --start gs_366 3.6.6 

# load tODE into stone
cd /bosch1/users/dhenrich/_stones/stones.gs_366
loadTode.stone --projectDirectory=$projectsDirectory

# create stone in custom stones directory
createStone.solo --root=/bosch1/users/dhenrich/_stones/stones --registry=$registryName --template=default_seaside --start gsd_3.6.6 3.6.6 

# load tODE into stone
cd /bosch1/users/dhenrich/_stones/stones.gsd_366
loadTode.stone --projectDirectory=$projectsDirectory

registryReport.solo
```

## Branches

### v1.1
Used by [smalltalkCI](https://github.com/hpi-swa/smalltalkCI).

### v1.1.1
Development aimed at smalltalkCI ... namely fixing [issue #322](https://github.com/dalehenrich/tode/issues/322).

## Branch naming conventions
1. vX
2. vX.Y
3. vX.Y.Z or vX.Y.Z-id

### vX
Stable production branch.

X is incremented whenever there is a breaking change.
vX.Y and vX.Y.Z branches are merged into the VX branch, when development is complete on the feature or patch.

### vX.Y
Stable feature/bugfix candidate branch.
 
Y is incremented whenever work on a new feature or bugfix is started.
vX.Y branches are merged into the VX branch when development is complete.

Primary work takes place on a vX.Y.Z branch and the VX.Y.Z branch is merged into the VX.Y branch at stable points, so if you want to have early access to a feature or bugfix, it is relatively safe to use this branch in production.

### vX.Y.Z
Unstable development branch.

Z is incremented whenever work on a new feature or bugfix is started.
A pre-release may be used to further identify the purpose of the work.

Primary work takes place on this branch and cannot be depended upon to be stable.

