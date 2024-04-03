#!/bin/bash
PKFILE=${1:-packages.yaml}
COMP=${2:-"gcc@9.4.0"}
TARGET=${3:-x86_64_v3}

# Detect HPCX in the image and install in spack
HPCX_DIR=$(ls -d /opt/hpcx*|tail -1)
HPCX_VER=$(echo $HPCX_DIR |sed 's/^.*hpcx-v\(.*\)-gcc.*$/\1/')
HCOLL_VER=$(/opt/mellanox/hcoll/bin/hcoll_info -v | sed 's/^Version: v\(.*\) .*$/\1/')
SLURM_VER=$(sinfo -V|awk '{print $2}')
UCC_VER=$(LD_LIBRARY_PATH=$HPCX_DIR/ucc/lib $HPCX_DIR/ucc/bin/ucc_info -v |grep version|sed 's/^.*version=\(.*\) revision.*$/\1/')
UCX_VER=$($HPCX_DIR/ucx/bin/ucx_info|grep "Library version"|sed 's/^.*version: \(.*\)$/\1/')

cat << EOF > $PKFILE
packages:
  hpcx-mpi:
      buildable: false
      externals:
       - spec: hpcx-mpi@$HPCX_VER %$COMP target=$TARGET
         prefix: $HPCX_DIR/ompi
  ucx:
    externals:
    - spec: ucx@1.15.0+cuda+xpmem+gdrcopy %$COMP target=$TARGET
      prefix: $HPCX_DIR/ucx
      depend_on: libiberty
    - spec: ucx@1.15.0+cuda+xpmem+gdrcopy+thread_multiple %$COMP target=$TARGET
      prefix: $HPCX_DIR/ucx/mt
      depend_on: libiberty
  ucc:
    externals:
    - spec: ucc@1.3.0+cuda %$COMP target=$TARGET
      prefix: $HPCX_DIR/ucc
  hcoll:
    externals:
    - spec: hcoll@$HCOLL_VER %$COMP target=$TARGET
      prefix: /opt/mellanox/hcoll
  slurm:
    externals:
    - spec: slurm@$SLURM_VER %$COMP target=$TARGET
      prefix: /usr
EOF
