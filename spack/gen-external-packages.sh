#!/bin/bash
PKFILE=packages.yaml

# Detect HPCX in the image and install in spack
HPCX_DIR=$(ls -d /opt/hpcx*|tail -1)
HPCX_VER=$(echo $HPCX_DIR |sed 's/^.*hpcx-v\(.*\)-gcc.*$/\1/')
HCOLL_VER=$(/opt/mellanox/hcoll/bin/hcoll_info -v | sed 's/^Version: v\(.*\) .*$/\1/')
SLURM_VER=$(sinfo -V|awk '{print $2}')

cat << EOF > $PKFILE
packages:
  hpcx-mpi:
      buildable: false
      externals:
       - spec: hpcx-mpi@$HPCX_VER
         prefix: $HPCX_DIR
  hcoll:
    externals:
    - spec: hcoll@$HCOLL_VER
      prefix: /opt/mellanox/hcoll
  slurm:
    externals:
    - spec: slurm@$SLURM_VER
      prefix: /usr
EOF
