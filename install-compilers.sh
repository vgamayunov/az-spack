#!/bin/bash
set -euo pipefail
. $HOME/spack/share/spack/setup-env.sh

function install_compiler {
    echo "*** Installing: $* ***"
    spack install $*
    spack load $*
    spack compiler find
    spack unload --all
}

install_compiler intel-oneapi-compilers@2022.2.0
# install_compiler aocc@3.2.0 +license-agreed
# install_compiler nvhpc@22.9 +mpi+lapack+blas install_type=network
install_compiler gcc@12.2.0
install_compiler gcc@11.1.0
