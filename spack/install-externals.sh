#!/bin/bash

. setenv.sh || exit 1

# Do not assign arch or compiler to the externals
# spack install -v hpcx-mpi
# spack install -v hcoll
# spack install -v ucx
# spack install -v ucc
# 
# exit 0

function install_package {
    echo "*** Installing: $* ***"
    spack install $* %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
}

install_package hpcx-mpi
install_package hcoll
install_package ucx
install_package ucc
install_package slurm
