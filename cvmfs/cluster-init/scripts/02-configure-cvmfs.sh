#!/bin/bash

cp $CYCLECLOUD_SPEC_PATH/files/default.local /etc/cvmfs/
cp $CYCLECLOUD_SPEC_PATH/files/azure.spack.conf /etc/cvmfs/config.d/
cp $CYCLECLOUD_SPEC_PATH/files/azure.spack.pub /etc/cvmfs/keys/

cvmfs_config setup
exit 0

# sudo cat > /etc/cvmfs/default.local <<EOF
# CVMFS_SERVER_URL=http://cvmfsserver/cvmfs/azure.spack
# CVMFS_HTTP_PROXY=DIRECT
# CVMFS_PUBLIC_KEY=/etc/cvmfs/keys/azure.spack.pub
# CVMFS_CACHE_BASE=/mnt/resource/cvmfs
# EOF

# sudo cat > /etc/cvmfs/config.d/azure.spack.conf <<EOF
# CVMFS_SERVER_URL=http://cvmfsserver/cvmfs/azure.spack
# CVMFS_PUBLIC_KEY=/etc/cvmfs/keys/azure.spack.pub
# EOF

# curl http://cvmfsserver/cvmfs/azure.spack/azure.spack.pub | sudo tee /etc/cvmfs/keys/azure.spack.pub

# sudo cvmfs_config setup
