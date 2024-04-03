#!/bin/bash
. setenv.sh
base_target=${SPACK_BASE_TARGET:-x86_64_v3}
base_comp=${SPACK_BASE_COMPILER:-gcc@9.4.0}

spack install openmpi%$base_comp +legacylaunchers +internal-libevent \
  fabrics=ucx,ucc,hcoll,knem schedulers=slurm target=$base_target

spack install --reuse openmpi@4.1.5%nvhpc +legacylaunchers +internal-libevent \
  fabrics=ucx,ucc,hcoll,knem schedulers=slurm target=$base_target \
  ^autoconf%$base_comp ^automake%$base_comp ^binutils%$base_comp ^gmake%$base_comp \
  ^hwloc%$base_comp ^knem%$base_comp ^libevent%$base_comp ^libtool%$base_comp \
  ^numactl%$base_comp  ^pkgconf%$base_comp ^pmix%$base_comp ^ucx+thread_multiple%$base_comp
spack install --reuse openmpi@4.1.5%intel@2021.10.0 +legacylaunchers +internal-libevent \
  fabrics=ucx,ucc,hcoll,knem schedulers=slurm target=$base_target \
  ^autoconf%$base_comp ^automake%$base_comp ^binutils%$base_comp ^gmake%$base_comp \
  ^hwloc%$base_comp ^knem%$base_comp ^libevent%$base_comp ^libtool%$base_comp \
  ^numactl%$base_comp  ^pkgconf%$base_comp ^pmix%$base_comp ^ucx+thread_multiple%$base_comp

exit 0

spack install --reuse openmpi%nvhpc +legacylaunchers +internal-pmix +internal-hwloc +internal-libevent \
      fabrics=ucx,ucc,hcoll,knem schedulers=slurm target=$base_target \
      ^autoconf%$base_comp ^automake%$base_comp ^binutils%$base_comp ^gmake%$base_comp \
      ^hwloc%$base_comp ^knem%$base_comp ^libevent%$base_comp ^libtool%$base_comp \
      ^numactl%$base_comp  ^pkgconf%$base_comp ^pmix%$base_comp \
      ^ucx+thread_multiple ^slurm%gcc
