#!/bin/bash

. setenv.sh || exit 1

function install_package {
    echo "*** Installing: $* ***"
    spack install $* %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
}

install_package python
install_package cmake

# Intel libraries
install_package intel-oneapi-mpi
install_package intel-oneapi-mkl
install_package intel-tbb
