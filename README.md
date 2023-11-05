# GsDevKit_stones
BRANCH | STATUS
------------- | -------------
**v1.1.1** | [![**v1.1.1** build status](https://github.com/GsDevKit/GsDevKit_stones/actions/workflows/ci.yml/badge.svg?branch=v1.1.1)](https://github.com/GsDevKit/GsDevKit_stones/actions)

## Versions
### v1.1.1
Development version intended for use with superDoit:v4.1 and GemStone 3.7.0 for .solo scripts. 
Supported Rowan v2 stone versions 3.6.4 and newer, tested through 3.7.0.
Supported Rowan v3 stone versions 3.7.0 and newer. tested through 3.7.0
Supported non-Rowan stone versions 3.5.3 and older (with 20.04 the limiting factor)

Greatly simplified version of GsDevKit_home
1. bin directory of scripts implemented with superDoit and 3.6.5 for solo scripts and GsHostProcess ala the .solo battery test drivers used internally
2. stone directory modeled after GsDevKit_home, but configurable for folks with different needs … some sort of template for definition of directory structure
3. registry of stones so that stones can be located anywhere
4. standard location for git repos
5. if you are using tODE I think you should continue using GsDevKit_home

## Installation
``` bash
git clone git@github.com:GsDevKit/GsDevKit_stones.git -b v1.1.1
GsDevKit_stones/bin/install.sh

export PATH=`pwd`/superDoit/bin:`pwd`/GsDevKit_stones/bin:$PATH
versionReport.solo
export GSDEVKIT_STONES_ROOT=`pwd`/GsDevKit_stones
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

createProjectSet.solo --registry=$registryName --projectSet=$projectSetName --key=server --ssh
createProjectSet.solo --registry=$registryName --projectSet=${projectSetName}_https --key=server --https

registerProjectDirectory.solo --registry=$registryName --projectDirectory=$projectsDirectory

cloneProjectsFromProjectSet.solo --registry=$registryName --projectSet=$projectSetName 
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
createStone.solo --registry=$registryName --template=default --start gs_366 3.6.6

# create stone in custom stones directory
createStone.solo --root=/bosch1/users/dhenrich/_stones/stones --registry=$registryName --template=default --start cust_3.6.6 3.6.6 

# create a tode stone in default stones directory (tODE loaded)
createStone.solo --registry=rogue --force --template=default_tode --start seaside_370 3.7.0

# create a rowan_v3 stone in default stones directory
createStone.solo --registry=rogue --template=minimal_rowan --start rowan_370_v3 3.7.0_rowanv3

registryReport.solo --registry=$registryName
```
## custom project set
```
createProjectSet.solo --registry=rogue --projectSet=rowan --empty

updateProjectSet.solo --registry=rogue --projectSet=rowan --projectName=Rowan --revision=masterV3.0 \
                      --gitUrl=git@github.com:GemTalk/Rowan.git
updateProjectSet.solo --registry=rogue --projectSet=rowan --projectName=Rowan --revision=masterV3.0 \
                      --remote=gs --gitUrl=git@git.gemtalksystems.com:Rowan

updateProjectSet.solo --registry=rogue --projectSet=rowan --projectName=RemoteServiceReplication --revision=main \
                      --gitUrl=git@github.com:GemTalk/RemoteServiceReplication.git

updateProjectSet.solo --registry=rogue --projectSet=rowan --projectName=RowanClientServices --revision=eric_component_V3.0 \
                      --gitUrl=git@github.com:GemTalk/RowanClientServices.git
updateProjectSet.solo --registry=rogue --projectSet=rowan --projectName=RowanClientServices --revision=eric_component_V3.0 \
                      --remote=gs --gitUrl=git@git.gemtalksystems.com:RowanClientServices

updateProjectSet.solo --registry=rogue --projectSet=rowan --projectName=PharoGemStoneFFI \
                      --gitUrl=git@github.com:GemTalk/PharoGemStoneFFI.git --revision=main

updateProjectSet.solo --registry=rogue --projectSet=rowan --projectName=JadeiteForPharo \
                      --gitUrl=git@github.com:GemTalk/JadeiteForPharo.git --revision=main

updateProjectSet.solo --registry=rogue --projectSet=rowan --projectName=Announcements \
                      --gitUrl=git@github.com:GemTalk/Announcements.git --revision=main

updateProjectSet.solo --registry=rogue --projectSet=rowan --projectName=GsDevKit_stones \
                      --gitUrl=git@github.com:GsDevKit/GsDevKit_stones.git --revision=v1.1.1
updateProjectSet.solo --registry=rogue --projectSet=rowan --projectName=GsDevKit_stones \
                      --remote=gs --gitUrl=git@git.gemtalksystems.com:GsDevKit_stones --revision=v1.1.1
```
## sample registry report
```
GDKStonesRegistry {
	#name : 'rogue',
	#parentRegistryName : 'rogue',
	#parentRegistryPath : '$STONES_DATA_HOME/gsdevkit_stones/registry.ston',
	#stones : {
		'seaside_370' : '$STONES_DATA_HOME/gsdevkit_stones/stones/rogue/seaside_370.ston',
		'gs_366' : '$STONES_DATA_HOME/gsdevkit_stones/stones/rogue/gs_366.ston',
		'rowan_370_v3' : '$STONES_DATA_HOME/gsdevkit_stones/stones/rogue/rowan_370_v3.ston'
	},
	#todeHome : '/home/dhenrich/_stones/tode',
	#stonesDirectory : '/home/dhenrich/_stones/stones',
	#sessions : { },
	#productDirectory : '/home/dhenrich/_stones/gemstone',
	#projectDirectory : '/home/dhenrich/_stones/git',
	#products : {
		'3.7.0' : '/secure/users/dhenrich/work/l_37x/noop50/gs/product',
		'3.6.6' : '/home/dhenrich/_homes/rogue/_home/shared/downloads/products/GemStone64Bit3.6.6-x86_64.Linux',
		'3.6.5' : '/home/dhenrich/_stones/git/superDoit/gemstone/products/GemStone64Bit3.6.5-x86_64.Linux',
		'3.7.0_rowanv3' : '/home/dhenrich/_homes/rogue/_home/shared/downloads/products/GemStone64Bit3.7.0_rowanv3-x86_64.Linux'
	},
	#projectSets : {
		'devkit' : '$STONES_DATA_HOME/gsdevkit_stones/projectSets/rogue/devkit.ston'
	},
	#templates : {
		'default_tode' : '$STONES_DATA_HOME/gsdevkit_stones/templates/default_tode.ston',
		'minimal_rowan' : '$STONES_DATA_HOME/gsdevkit_stones/templates/minimal_rowan.ston',
		'default_rowan' : '$STONES_DATA_HOME/gsdevkit_stones/templates/default_rowan.ston',
		'default' : '$STONES_DATA_HOME/gsdevkit_stones/templates/default.ston',
		'minimal_seaside' : '$STONES_DATA_HOME/gsdevkit_stones/templates/minimal_seaside.ston',
		'minimal' : '$STONES_DATA_HOME/gsdevkit_stones/templates/minimal.ston'
	}
}
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

