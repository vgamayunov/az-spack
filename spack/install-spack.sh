#!/bin/bash
set -euo pipefail

BASE_COMPILER=gcc@9.4.0
BASE_TARGET=x86_64_v3

mydir=$(readlink -f $(dirname $0))

git clone -c feature.manyFiles=true --branch=releases/v0.22 https://github.com/spack/spack.git
source spack/share/spack/setup-env.sh
spack config --scope defaults add config:build_jobs:32
spack config --scope defaults add config:build_stage:/mnt/scratch/\$user/spack-stage

# spack incorrectly identifies the azure cpu architectures for certain skus (an azure issue, not a spack issue)
# the workaround is to edit the microarchitectures.json file in the spack tree.
# https://github.com/spack/spack/issues/12896
# known deviations: 
# HB60rs/Standard_HB60rs - cpuinfo missing "clzero" instruction (misidentifies zen as excavator)
# HBv3/Standard_HB120rs_v3 - cpuinfo missing "pku" instruction (misidentifies zen3 as zen2)
# HBv4/Standard_HB176_v4 - missing "pku", "flush_l1d"
MICROARCHFILE=$SPACK_ROOT/lib/spack/external/archspec/json/cpu/microarchitectures.json
mv $MICROARCHFILE ${MICROARCHFILE}.orig
cat ${MICROARCHFILE}.orig | \
	jq 'del(.microarchitectures.zen.features[] | select (. == "clzero"))' | \
	jq 'del(.microarchitectures.zen3.features[] | select (. == "pku"))' | \
	jq 'del(.microarchitectures.zen4.features[] | select (. == "pku" or . == "flush_l1d"))' >$MICROARCHFILE

mkdir apps modules
touch spack/.cvmfscatalog
touch apps/.cvmfscatalog
touch modules/.cvmfscatalog

$mydir/find-external-versions.sh $SPACK_ROOT/versions.yaml $BASE_COMPILER $BASE_TARGET
$mydir/gen-external-packages.sh $SPACK_ROOT/versions.yaml $SPACK_ROOT/etc/spack/packages.yaml
appsdir=$(readlink -f apps)
modulesdir=$(readlink -f modules)
sed "s/__APPSDIR__/$appsdir/g" $mydir/config.yaml > $SPACK_ROOT/etc/spack/config.yaml
sed "s/__MODULESDIR__/$modulesdir/g" $mydir/modules.yaml > $SPACK_ROOT/etc/spack/modules.yaml

spack compiler find --scope=site

cat > setenv.sh <<EOF
$mydir/find-external-versions.sh /tmp/versions.yaml
diff /tmp/versions.yaml $SPACK_ROOT/versions.yaml || echo "WARNING: versions in the OS image are different from this SPACK root"
source $(readlink -f spack/share/spack/setup-env.sh)
export SPACK_BASE_COMPILER=$BASE_COMPILER
export SPACK_BASE_TARGET=$BASE_TARGET
EOF

