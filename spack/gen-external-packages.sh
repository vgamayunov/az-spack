#!/bin/bash
set -euo pipefail
VERSIONS_FILE=${1:-versions.yaml}
PKFILE=${2:-packages.yaml}

if [ ! -e $VERSIONS_FILE ] ; then
  echo ERROR: Unable to open version file "$VERSIONS_FILE"
  exit 1
fi

COMP=$(grep "^base_compiler:" $VERSIONS_FILE | awk '{print $1}')
TARGET=$(grep "^base_target:" $VERSIONS_FILE | awk '{print $1}')
HPCX_VER=$(grep "^hpcx:" $VERSIONS_FILE | awk '{print $1}')
UCX_VER=$(grep "^ucx:" $VERSIONS_FILE | awk '{print $1}')
UCC_VER=$(grep "^ucc:" $VERSIONS_FILE | awk '{print $1}')
HCOLL_VER=$(grep "^hcoll:" $VERSIONS_FILE | awk '{print $1}')
SLURM_VER=$(grep "^slurm:" $VERSIONS_FILE | awk '{print $1}')
CUDA_VER=$(grep "^cuda:" $VERSIONS_FILE | awk '{print $1}')

cat << EOF > $PKFILE
packages:
  hpcx-mpi:
      buildable: false
      externals:
       - spec: hpcx-mpi@$HPCX_VER %$COMP target=$TARGET
         prefix: $HPCX_DIR/ompi
  ucx:
    externals:
    - spec: ucx@$UCX_VER+cuda+xpmem+gdrcopy %$COMP target=$TARGET
      prefix: $HPCX_DIR/ucx
      depend_on: libiberty
    - spec: ucx@$UCX_VER+cuda+xpmem+gdrcopy+thread_multiple %$COMP target=$TARGET
      prefix: $HPCX_DIR/ucx/mt
      depend_on: libiberty
  ucc:
    externals:
    - spec: ucc@$UCC_VER+cuda %$COMP target=$TARGET
      prefix: $HPCX_DIR/ucc
  hcoll:
    externals:
    - spec: hcoll@$HCOLL_VER %$COMP target=$TARGET
      prefix: /opt/mellanox/hcoll
  slurm:
    externals:
    - spec: slurm@$SLURM_VER %$COMP target=$TARGET
      prefix: /usr
  cuda:
    externals:
    - spec: cuda@$CUDA_VER %$COMP target=$TARGET
      prefix: /usr/local/cuda-$CUDA_VER
EOF
