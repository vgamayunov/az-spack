#!/bin/bash

. setenv.sh

spack install hpcx-mpi %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
spack install hcoll %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
spack install ucx %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
spack install ucc %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET
