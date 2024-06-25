#!/bin/bash
. setenv.sh || exit 1

function install_compiler {
    echo "*** Installing: $* ***"
    spack install $* %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
    spack load $* 
    spack compiler find --scope=site
    spack unload --all
}

install_compiler gcc@12.3.0
install_compiler intel-oneapi-compilers@2024.1.0
install_compiler intel-oneapi-compilers-classic@2021.10.0
install_compiler aocc@4.2.0 +license-agreed
install_compiler nvhpc@24.3
