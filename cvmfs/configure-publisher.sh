#!/bin/bash
set -euo pipefail

SERVER=${1:-cvmfsserver}
KEYDIR=${2:-/tmp/tmpkeys}
REPONAMES="ape.core"

for repo in $REPONAMES ; do
  if [ ! -f $KEYDIR/$repo.pub -o ! -f $KEYDIR/$repo.crt -o ! -f $KEYDIR/$repo.gw ] ; then
    echo Certificates not found in $KEYDIR. Files required: $repo.pub $repo.crt $repo.gw
    exit 1
  fi
  cp $KEYDIR/$repo.pub $KEYDIR/$repo.crt $KEYDIR/$repo.gw /etc/cvmfs/keys/
  cvmfs_server mkfs -w http://$SERVER/cvmfs/$repo -u gw,/srv/cvmfs/$repo/data/txn,http://$SERVER:4929/api/v1 -k /etc/cvmfs/keys -o root $repo
done
