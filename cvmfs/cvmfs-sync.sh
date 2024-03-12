#!/bin/bash
set -euo pipefail
REPO=azure.spack
DEFAULT_CVMFS_PATH=/cvmfs/$REPO/1.0.2
DEFAULT_BUILD_PATH=/mnt/resource/cvmfs-spack

CMD=${1-:"help"}

if [ "$CMD" == "clone" ] ; then
    CVMFSPATH=${2:-$DEFAULT_CVMFS_PATH}
    BUILDPATH=${3:-$DEFAULT_BUILD_PATH}
    echo "Copying spack image from CVMFS to $BUILDPATH..."
    mkdir -p $BUILDPATH
    [ -d $CVMFSPATH/spack ] && rsync -rlptDv $CVMFSPATH/* $BUILDPATH/

    # Unmount CVMFS and bind
    sudo systemctl stop autofs
    sudo mkdir -p $CVMFSPATH
    sudo mount --bind $BUILDPATH $CVMFSPATH

    [ -d ~/.spack ] && mv -v ~/.spack ~/.spack-cvmfssave

    echo "CVMFS is mounted r/w in $CVMFSPATH and ready to make changes."
    echo "Run 'source $CVMFSPATH/spack/share/spack/setup-env.sh' to initialize the build environment."
elif [ "$CMD" == "push" ] ; then
    CVMFSSERVER=${2:-cvmfsserver}
    CVMFSPATH=${3:-$DEFAULT_CVMFS_PATH}
    BUILDPATH=${4:-$DEFAULT_BUILD_PATH}
    echo "Make sure ssh connection to the root user on $CVMFSSERVER is working."
    echo "Starting transaction on the CVMFS Stratum 0 server..."
    ssh root@$CVMFSSERVER cvmfs_server transaction $REPO

    echo "About to run the following command:"
    echo "    rsync -rlptDv --delete $CVMFSPATH/* root@$CVMFSSERVER:$CVMFSPATH/"
    echo "Press ENTER to continue"
    read

    echo "Pushing files to the Stratum 0 server (will delete files not present here)..."
    rsync -rlptDv --delete $CVMFSPATH/* root@$CVMFSSERVER:$CVMFSPATH/

    echo "Remounting CVMFS..."
    # Remove bind
    sudo umount $CVMFSPATH
    sudo systemctl start autofs

    # Cleanup
    rm -rf ~/.spack
    [ -d ~/.spack-cvmfssave ] && mv -v ~/.spack-cvmfssave ~/.spack

    echo "Publishing the repository on the server..."
    ssh root@$CVMFSSERVER cvmfs_server publish $REPO

    echo "Updating client cache..."
    sudo cvmfs_config reload
    echo "Repository is kept locally in $BUILDPATH - next time clone will only copy the differences"
else
    echo "Usage: $0 <command>"
    echo "  Commands:"
    echo "    clone CVMFS_PATH BUILD_PATH                make a copy of CVMFS and prepare for modification"
    echo "    push CVMFS_SERVER CVMFS_PATH BUILD_PATH    upload BUILD_PATH back to CVMFS"
    echo "    help                                       display this message"
    exit 1
fi
