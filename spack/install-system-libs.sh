#!/bin/bash

. setenv.sh || exit 1

function install_package {
    echo "*** Installing: $* ***"
    spack install $* %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
}

install_package xpmem@2.6.5
install_package cuda@12.4.0

install_package --reuse ucx@1.16.0 +cuda+xpmem+thread_multiple+gdrcopy+dc+rc+ud ^xpmem@2.6.5 ^cuda@12.4.0
install_package nccl@2.20.3-1 cuda_arch=80,90 ^cuda@12.4.0
install_package --reuse ucc@1.3.0 ^ucx@1.16.0
