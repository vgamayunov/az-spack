#!/bin/bash

. spack/share/spack/setup-env.sh

function install_compiler {
    echo "*** Installing: $* ***"
    spack install $*
    spack load $*
    spack compiler find --scope=site
    spack unload --all
}

install_compiler gcc
install_compiler intel-oneapi-compilers
install_compiler aocc +license-agreed
install_compiler nvhpc
