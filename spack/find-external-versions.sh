#!/bin/bash
VERSIONS_FILE=${1:-versions.yaml}
COMP=${2:-"gcc@9.4.0"}
TARGET=${3:-x86_64_v3}

# Detect HPCX in the image and install in spack
HPCX_DIR=$(ls -d /opt/hpcx*|tail -1)
HPCX_VER=$(echo $HPCX_DIR |sed 's/^.*hpcx-v\(.*\)-gcc.*$/\1/')
HCOLL_VER=$(/opt/mellanox/hcoll/bin/hcoll_info -v | sed 's/^Version: v\(.*\) .*$/\1/')
SLURM_VER=$(sinfo -V|awk '{print $2}')
UCC_VER=$(LD_LIBRARY_PATH=$HPCX_DIR/ucc/lib $HPCX_DIR/ucc/bin/ucc_info -v |grep version|sed 's/^.*version=\(.*\) revision.*$/\1/')
UCX_VER=$($HPCX_DIR/ucx/bin/ucx_info -v|grep "Library version"|sed 's/^.*version: \(.*\)$/\1/')
CUDA_VER=$(readlink -f /usr/local/cuda | sed 's/^.*cuda-//')

cat << EOF > $VERSIONS_FILE
base_compiler: $COMP
base_target: $TARGET
slurm: $SLURM_VER
hcoll: $HCOLL_VER
ucx: $UCX_VER
ucc: $UCC_VER
cuda: $CUDA_VER
hpcx: $HPCX_VER
hpcx_dir: $HPCX_DIR
EOF
