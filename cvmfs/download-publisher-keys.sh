#!/bin/bash
# Requires ssh access to cvmfs server
SERVER=cvmfsserver
SSHUSER=hpcadmin
SSHKEY=~/cvmfs/hpcadmin_id_rsa
REPOLIST="ape.core azure.pe"

KEYDIR=${1:-/tmp/tmpkeys}
mkdir -p $KEYDIR

echo Downloading CVMFS keys from $SERVER into $KEYDIR ...

for repo in $REPOLIST ; do
  for ext in  crt gw pub ; do
    scp -i $SSHKEY $SSHUSER@$SERVER:/etc/cvmfs/keys/$repo.$ext $KEYDIR/
  done
done

