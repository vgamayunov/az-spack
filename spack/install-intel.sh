#!/bin/bash
. setenv.sh || exit 1

spack install intel-oneapi-mpi %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
spack install intel-oneapi-mkl %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
