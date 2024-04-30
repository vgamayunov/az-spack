#!/bin/bash
. setenv.sh || exit 1

set -euo pipefail

function install_package {
  pkg=$1
  comp=$2
  mpi=$3
  echo "*** Installing: $pkg using compiler $comp and MPI $mpi ***"
  spack install --reuse $pkg%$comp ^$mpi%$comp
}

install_package intel-mpi-benchmarks intel@2021.10.0 openmpi
install_package intel-mpi-benchmarks nvhpc openmpi
