#!/bin/bash
. setenv.sh || exit 1
base_target=${SPACK_BASE_TARGET:-x86_64_v3}
base_comp=${SPACK_BASE_COMPILER:-gcc@9.4.0}

set -euo pipefail

function install_openmpi1 {
    echo "*** Installing: $* ***"
    spack spec --reuse $* +legacylaunchers +internal-libevent \
      fabrics=ucx,ucc,hcoll schedulers=slurm target=$base_target \
      ^autoconf%$base_comp ^automake%$base_comp ^binutils+libiberty%$base_comp ^gmake%$base_comp \
      ^hwloc%$base_comp ^libevent%$base_comp ^libtool%$base_comp \
      ^numactl%$base_comp  ^pkgconf%$base_comp ^pmix%$base_comp \
      ^ucx@1.15.0+thread_multiple+cuda+gdrcopy+xpmem%$base_comp target=$base_target \
      ^slurm@23.02.7%$base_comp
}
function install_openmpi {
    echo "*** Installing: $* ***"
    spack install --reuse $* +legacylaunchers +internal-libevent \
      fabrics=ucx,ucc,hcoll schedulers=slurm target=$base_target \
      ^autoconf%$base_comp ^automake%$base_comp ^binutils+libiberty%$base_comp ^gmake%$base_comp \
      ^hwloc%$base_comp ^libevent%$base_comp ^libtool%$base_comp \
      ^numactl%$base_comp  ^pkgconf%$base_comp ^pmix%$base_comp \
      ^ucc%$base_comp ^ucx+thread_multiple%$base_comp ^slurm%$base_comp
}


# Patch Open MPI package to require libiberty
sed -i '/when("fabrics=ucx")/a \        depends_on("binutils+libiberty")' $SPACK_ROOT/var/spack/repos/builtin/packages/openmpi/package.py

# Install base version of Open MPI and all dependencies
spack spec --reuse openmpi@4.1.5%$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET +legacylaunchers +internal-libevent fabrics=ucx,ucc,hcoll schedulers=slurm

# install_openmpi openmpi@4.1.5%$base_comp
# exit 0
install_openmpi openmpi@4.1.5%nvhpc@24.3
install_openmpi openmpi@4.1.5%intel@2021.10.0
install_openmpi openmpi@4.1.5%oneapi@2024.1.0


exit 0
spack install --reuse openmpi%$base_comp +legacylaunchers +internal-libevent \
  fabrics=ucx,ucc,hcoll schedulers=slurm target=$base_target \
  ^autoconf%$base_comp ^automake%$base_comp ^binutils%$base_comp ^gmake%$base_comp \
  ^hwloc%$base_comp ^libevent%$base_comp ^libtool%$base_comp \
  ^numactl%$base_comp  ^pkgconf%$base_comp ^pmix%$base_comp ^ucx+thread_multiple%$base_comp
# exit 0
# fabrics=ucx,ucc,hcoll,knem

spack install --reuse openmpi@4.1.5%nvhpc +legacylaunchers +internal-libevent \
  fabrics=ucx,ucc,hcoll schedulers=slurm target=$base_target \
  ^autoconf%$base_comp ^automake%$base_comp ^binutils%$base_comp ^gmake%$base_comp \
  ^hwloc%$base_comp ^libevent%$base_comp ^libtool%$base_comp \
  ^numactl%$base_comp  ^pkgconf%$base_comp ^pmix%$base_comp ^ucx+thread_multiple%$base_comp
spack install --reuse openmpi@4.1.5%intel@2021.10.0 +legacylaunchers +internal-libevent \
  fabrics=ucx,ucc,hcoll schedulers=slurm target=$base_target \
  ^autoconf%$base_comp ^automake%$base_comp ^binutils%$base_comp ^gmake%$base_comp \
  ^hwloc%$base_comp ^libevent%$base_comp ^libtool%$base_comp \
  ^numactl%$base_comp  ^pkgconf%$base_comp ^pmix%$base_comp ^ucx+thread_multiple%$base_comp

exit 0

spack install --reuse openmpi%nvhpc +legacylaunchers +internal-pmix +internal-hwloc +internal-libevent \
      fabrics=ucx,ucc,hcoll,knem schedulers=slurm target=$base_target \
      ^autoconf%$base_comp ^automake%$base_comp ^binutils%$base_comp ^gmake%$base_comp \
      ^hwloc%$base_comp ^knem%$base_comp ^libevent%$base_comp ^libtool%$base_comp \
      ^numactl%$base_comp  ^pkgconf%$base_comp ^pmix%$base_comp \
      ^ucx+thread_multiple ^slurm%gcc
