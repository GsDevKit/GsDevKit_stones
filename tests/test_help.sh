#! /usr/bin/env bash
#
# test --help for all .solo scripts in bin
#		
set -e

echo "***** test_help.sh *****"

cloneProjectsFromProjectSet.solo -h
createProjectSet.solo -h
createRegistry.solo -h
createStone.solo -h
deleteStone.solo -h
downloadGemStone.solo -h
generateGsDevKitProjectSet.solo -h
gslist.solo --help
newExtent.solo --help
registerProductDirectory.solo -h
registerProduct.solo -h
registerProjectDirectory.solo -h
registerStonesDirectory.solo -h
registerStone.solo -h
registerTodeSharedDir.solo -h
registryQuery.solo -h
registryReport.solo --help
startNetldi.solo --help
startStone.solo -h
stopNetldi.solo --help
stopStone.solo --help
template.solo -h
todeIt.solo -h
updateClientLibs.solo -h
updateCustomEnv.solo -h
updateProjectSet.solo --help
versionReport.gs_solo -h
versionReport.solo -h
