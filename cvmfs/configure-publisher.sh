#!/bin/bash
set -euo pipefail

REPONAME=ape.core
SERVER=cvmfsserver
KEYDIR=${1:-.}

if [ ! -f $KEYDIR/$REPONAME.pub -o ! -f $KEYDIR/$REPONAME.crt -o ! -f $KEYDIR/$REPONAME.gw ] ; then
  echo Certificates not found in $KEYDIR. Files required: $REPONAME.pub $REPONAME.crt $REPONAME.gw
  exit 1
fi

mkdir /tmp/keys
cp $KEYDIR/$REPONAME.pub $KEYDIR/$REPONAME.crt $KEYDIR/$REPONAME.gw /tmp/keys

cvmfs_server mkfs -w http://$SERVER/cvmfs/$REPONAME -u gw,/srv/cvmfs/$REPONAME/data/txn,http://$SERVER:4929/api/v1 -k /tmp/keys -o root $REPONAME
rm -rf /tmp/keys
