#!/bin/bash

. setenv.sh

# Do not assign arch or compiler to the externals
spack install hpcx-mpi
spack install hcoll
spack install ucx
spack install ucc

exit 0

spack install hpcx-mpi %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
spack install hcoll %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
spack install ucx %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
spack install ucc %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
