#!/bin/bash
set -euo pipefail
REPO=ape.core
VERSION=1.0.1

if [ -d /cvmfs/$REPO/$VERSION/spack ]; then
    echo ERROR: Found existing Spack install at /cvmfs/$REPO/$VERSION/spack
    echo Did you mean to change the version number?
    exit 1
fi

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
