#!/bin/bash
set -euo pipefail

apt-get update
apt-get install -y cvmfs-server

# Publisher may discard cvmfs directories when rebooted
mkdir -pv /mnt/resource/cvmfs_srv /mnt/resource/cvmfs
ln -sf /mnt/resource/cvmfs /var/spool/cvmfs
ln -sf /mnt/resource/cvmfs_srv /srv/cvmfs

systemctl stop autofs
systemctl disable autofs
