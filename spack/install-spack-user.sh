#!/bin/bash

export SPACK_ROOT=$HOME/spack
export SPACK_CORE=/cvmfs/ape.core/spack

# Install Spack for the user
git clone -c feature.manyFiles=true --branch=releases/v0.22 https://github.com/spack/spack.git $SPACK_ROOT

ARCH_FILE=lib/spack/external/archspec/json/cpu/microarchitectures.json

cp $SPACK_CORE/etc/spack/compilers.yaml $SPACK_ROOT/etc/spack/compilers.yaml
cp $SPACK_CORE/$ARCH_FILE $SPACK_ROOT/$ARCH_FILE
cat > $SPACK_ROOT/etc/spack/upstreams.yaml <<EOF
upstreams:
  spack-shared:
    install_tree: /cvmfs/ape.core/apps
EOF

source $SPACK_ROOT/share/spack/setup-env.sh

spack config --scope defaults add config:build_jobs:32
spack config --scope defaults add config:build_stage:/mnt/scratch/\$user/spack-stage
