#!/bin/bash
REPOS="ape.core ape.libs"
for r in $REPOS ; do
  cvmfs_server resign $r
done
