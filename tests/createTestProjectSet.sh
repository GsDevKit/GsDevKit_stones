#! /usr/bin/env bash

set -e

registry=test
projectSet=xxx

if [ ! -d $STONES_HOME/test_git ]; then
	mkdir $STONES_HOME/test_git
fi

set +e
registryReport.solo --registry=$registry
status=$?

set -e

if [ $status == 1 ]; then
	echo "creating $registry registry"
	createRegistry.solo $registry
else
	echo "registry $registry exists"
fi

set +e
createProjectSet.solo --registry=$registry --projectSet=$projectSet --empty $*
status=$?

if [ $status == 1 ]; then
	echo "project set $projectSet exists"
fi

updateProjectSet.solo --registry=$registry --projectSet=$projectSet \
            --projectName=GsDevKit_stones \
            --gitUrl=git@github.com:GsDevKit/GsDevKit_stones.git \
						--remote=origin \
						--revision=v1.1.1 $*

updateProjectSet.solo --registry=$registry --projectSet=$projectSet \
            --projectName=GsDevKit_stones \
            --gitUrl=git@git.gemtalksystems.com:GsDevKit_stones \
						--remote=gs \
						--revision=v1.1.1  $*


