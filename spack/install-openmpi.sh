#!/bin/bash

corecomp=gcc@9.4.0
corearch=linux-ubuntu20.04-zen2

. spack/share/spack/setup-env.sh

spack install openmpi%$corecomp +legacylaunchers fabrics=ucx,ucc,hcoll,knem schedulers=slurm arch=$corearch
spack install --reuse openmpi%nvhpc +legacylaunchers fabrics=ucx,ucc,hcoll,knem schedulers=slurm arch=$corearch \
      ^autoconf%$corecomp ^automake%$corecomp ^binutils%$corecomp ^gmake%$corecomp \
      ^hwloc%$corecomp ^knem%$corecomp ^libevent%$corecomp ^libtool%$corecomp \
      ^numactl%$corecomp  ^pkgconf%$corecomp ^pmix%$corecomp
