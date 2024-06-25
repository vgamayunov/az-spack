#!/bin/bash
set -euo pipefail
REPO=ape.core
VERSION=1.0.1

mydir=$(dirname $(reaflink -f $0))

function run_and_publish {
    cvmfs_server transaction $REPO
    cd /cvmfs/$REPO/$VERSION
    $mydir/$1
    cd
    cvmfs_server publish
}

run_and_publish install_spack.sh
run_and_publish install_externals.sh
run_and_publish install_compilers.sh
run_and_publish install_common.sh
run_and_publish install_system-libs.sh
run_and_publish install_openmpi.sh
