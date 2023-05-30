# GsDevKit_stones
Greatly simplified version of GsDevKit_home
1. bin directory of scripts implemented with superDoit and 3.6.5 for solo scripts and GsHostProcess ala the .solo battery test drivers used internally
2. stone directory modeled after GsDevKit_home, but configurable for folks with different needs … some sort of template for definition of directory structure
3. registry of stones so that stones can be located anywhere
4. standard location for git repos
5. if you are using tODE I think you should continue using GsDevKit_home

After running install add superDoit/bin and GsDevKit_stones/bin to $PATH

## Setting up the registry structure
```bash
registryName="issue_4"
projectSetName="gsdevkit"
gemstoneProductsDirectory=""
projectsDirectory="/bosch1/users/dhenrich/_git/"

createRegistry.solo $registryName
createProjectSet.solo --registry=$registryName --projectSet=$projectSetName --ssh
cloneProjectsFromProjectSet.solo --registry=$registryName --projectSet=$projectSetName \
  --projectDirectory=$projectsDirectory
registerProductDirectory.solo --registry=$registryName --productDirectory=$projectsDirectory

# GemStone version not previously downloaded
downloadGemStone.solo --directory=$gemstoneProductsDirectory --registry=$registryName 3.6.6
# GemStone version previously downloaded
registerProduct.solo --registry=$registryName --fromDirectory=$GS_HOME/shared/downloads/products 3.6.6
# internal development
registerProduct.solo --registry=$registryName --fromDirectory=/bosch1/users/dhenrich/_work/d_37x/noop50/gs/product 3.7.0

registryReport.solo
```

## Create a stone
```bash
stoneDirectoryPath=$GS_HOME/server/stones/gs_366
createStone.solo --force --registry=$registryName --template=default_seaside \
				--start --root=stoneDirectoryPath 3.6.6

registryReport.solo
```

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

