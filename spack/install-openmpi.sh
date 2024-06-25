#!/bin/bash
. setenv.sh || exit 1
base_target=${SPACK_BASE_TARGET:-x86_64_v3}
base_comp=${SPACK_BASE_COMPILER:-gcc@9.4.0}

UCX_VER=1.16.0
UCC_VER=1.3.0
MPI_VER=4.1.5

set -euo pipefail

function install_openmpi {
    echo "*** Installing: $* ***"
    spack install --reuse $* +legacylaunchers +internal-libevent \
      fabrics=ucx,ucc,hcoll schedulers=slurm target=$base_target \
      ^autoconf%$base_comp ^automake%$base_comp ^binutils+libiberty%$base_comp \
      ^gmake%$base_comp ^hwloc%$base_comp ^libevent%$base_comp ^libtool%$base_comp \
      ^numactl%$base_comp ^pkgconf%$base_comp ^pmix%$base_comp \
      ^ucc@$UCC_VER%$base_comp ^ucx@$UCX_VER+cuda+xpmem+thread_multiple+gdrcopy+dc+rc+ud%$base_comp \
      ^hcoll%$base_comp ^slurm%$base_comp
}


# Patch Open MPI package to require libiberty
sed -i '/when("fabrics=ucx")/a \        depends_on("binutils+libiberty")' $SPACK_ROOT/var/spack/repos/builtin/packages/openmpi/package.py

# Install base version of Open MPI and all dependencies
# spack install --reuse openmpi@4.1.5%$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET \
#   +legacylaunchers +internal-libevent fabrics=ucx,ucc,hcoll schedulers=slurm \
#   ^ucx@1.16.0+cuda+xpmem+thread_multiple ^ucc@1.3.0

# spack install --reuse openmpi@4.1.5%$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET +legacylaunchers +internal-libevent fabrics=ucx,ucc,hcoll schedulers=slurm

install_openmpi openmpi@$MPI_VER%$base_comp
install_openmpi openmpi@$MPI_VER%nvhpc@24.3
install_openmpi openmpi@$MPI_VER%intel@2021.10.0
install_openmpi openmpi@$MPI_VER%oneapi@2024.1.0
