#!/bin/bash
set -euo pipefail

SPACK_DIR=$HOME/spack

git clone https://github.com/spack/spack.git $SPACK_DIR
. $SPACK_DIR/share/spack/setup-env.sh

# spack mis-identifies the azure cpu architectures for certain skus (an azure issue, not a spack issue)
# The workaround is to edit the microarchitectures.json file in the spack tree. 
# https://github.com/spack/spack/issues/12896
# Known deviations: 
# HB60rs/standard_hb60rs - cpuinfo missing "clzero" instruction (misidentifies zen as excavator)
# HBv3/standard_hb120rs_v3 - cpuinfo missing "pku" instruction (misidentifies zen3 as zen2)
SPACK_ARCH=$SPACK_DIR/lib/spack/external/archspec/json/cpu
cp $SPACK_ARCH/microarchitectures.json $SPACK_ARCH/microarchitectures.json.backup
jq 'del((.microarchitectures.zen3.features[] | select (. == "pku")), (.microarchitectures.zen.features[] | select (. == "clzero")))'  $SPACK_ARCH/microarchitectures.json.backup > $SPACK_ARCH/microarchitectures.json

# Default to make -j 32 and staging directory in /mnt/resource (otherwise may run out of space in /tmp)
spack config --scope defaults add config:build_jobs:32
spack config --scope defaults add config:build_stage:'/mnt/resource/$user/spack-stage'

# Detect HPCX in the image and install in spack
HPCX_DIR=$(ls -d /opt/hpcx*|tail -1)
HPCX_VER=$(echo $HPCX_DIR |sed 's/^.*hpcx-v\(.*\)-gcc.*$/\1/')
cat << EOF >> $SPACK_DIR/etc/spack/packages.yaml
packages:
  hpcx-mpi:
      buildable: false
      externals:
       - spec: hpcx-mpi@$HPCX_VER
         prefix: $HPCX_DIR
EOF
spack install hpcx-mpi@$HPCX_VER

# Don't have to use Intel MPI from the image - install from repo
spack install intel-oneapi-mpi@2021.7.0
