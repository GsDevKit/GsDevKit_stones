#! /usr/bin/env bash
#
# test --help for all .solo scripts in bin
#		
set -e

echo "***** test_help.sh *****"

TEST_SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

$TEST_SCRIPTS_DIR/cloneProjectsFromProjectSet.solo -h
$TEST_SCRIPTS_DIR/createProjectSet.solo -h
$TEST_SCRIPTS_DIR/createRegistry.solo -h
$TEST_SCRIPTS_DIR/createStone.solo -h
$TEST_SCRIPTS_DIR/deleteStone.solo -h
$TEST_SCRIPTS_DIR/downloadGemStone.solo -h
$TEST_SCRIPTS_DIR/generateGsDevKitProjectSet.solo -h
$TEST_SCRIPTS_DIR/gslist.solo -h
$TEST_SCRIPTS_DIR/loadSmalltalkCIProject.stone -h
$TEST_SCRIPTS_DIR/loadTode.stone -h
$TEST_SCRIPTS_DIR/registerProductDirectory.solo -h
$TEST_SCRIPTS_DIR/registerProduct.solo -h
$TEST_SCRIPTS_DIR/registerProjectDirectory.solo -h
$TEST_SCRIPTS_DIR/registerStonesDirectory.solo -h
$TEST_SCRIPTS_DIR/registerStone.solo -h
$TEST_SCRIPTS_DIR/registerTodeSharedDir.solo -h
$TEST_SCRIPTS_DIR/registryReport.solo -h
$TEST_SCRIPTS_DIR/startNetldi.solo -h
$TEST_SCRIPTS_DIR/startStone.solo -h
$TEST_SCRIPTS_DIR/stopNetldi.solo -h
$TEST_SCRIPTS_DIR/stopStone.solo -h
$TEST_SCRIPTS_DIR/template.solo -h
$TEST_SCRIPTS_DIR/todeIt.solo -h
$TEST_SCRIPTS_DIR/updateCustomEnv.solo -h
$TEST_SCRIPTS_DIR/updateProjectSet.solo -h
$TEST_SCRIPTS_DIR/versionReport.gs_solo -h
$TEST_SCRIPTS_DIR/versionReport.solo -h
