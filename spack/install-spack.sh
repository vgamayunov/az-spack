#!/bin/bash
set -euo pipefail

git clone https://github.com/spack/spack.git
source spack/share/spack/setup-env.sh
spack config --scope defaults add config:build_jobs:32
spack config --scope defaults add config:build_stage:/mnt/scratch/$user/spack-stage

# spack incorrectly identifies the azure cpu architectures for certain skus (an azure issue, not a spack issue)
# the workaround is to edit the microarchitectures.json file in the spack tree.
# https://github.com/spack/spack/issues/12896
# known deviations: 
# HB60rs/Standard_HB60rs - cpuinfo missing "clzero" instruction (misidentifies zen as excavator)
# HBv3/Standard_HB120rs_v3 - cpuinfo missing "pku" instruction (misidentifies zen3 as zen2)
MICROARCHFILE=$SPACK_ROOT/lib/spack/external/archspec/json/cpu/microarchitectures.json
mv $MICROARCHFILE ${MICROARCHFILE}.orig
cat ${MICROARCHFILE}.orig | jq 'del(.microarchitectures.zen3.features[] | select (. == "pku"))' | jq 'del(.microarchitectures.zen.features[] | select (. == "clzero"))' >$MICROARCHFILE

./gen-external-packages.sh

cp -fv packages.yaml modules.yaml $SPACK_ROOT/etc/spack/
spack compiler find --scope=site