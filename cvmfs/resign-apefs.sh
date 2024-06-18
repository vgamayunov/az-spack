#!/bin/bash
REPOS="ape.core"
for r in $REPOS ; do
  cvmfs_server resign $r
done
