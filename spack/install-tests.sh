#!/bin/bash
. setenv.sh || exit 1

set -euo pipefail

spack install intel-mpi-benchmarks %$SPACK_BASE_COMPILER ^openmpi%$SPACK_BASE_COMPILER
spack install intel-mpi-benchmarks %nvhpc@24.3 ^openmpi%nvhpc
spack install intel-mpi-benchmarks %intel@2021.10.0 ^openmpi%intel@2021.10.0
spack install intel-mpi-benchmarks %intel@2021.10.0 ^intel-oneapi-mpi
