#!/bin/bash
set -euo pipefail

# Publisher may discard cvmfs directories when rebooted
mkdir -pv /mnt/resource/cvmfs_srv /mnt/resource/cvmfs
[ -d /var/spool/cvmfs ] && mv /var/spool/cvmfs /var/spool/cvmfs-save
[ -d /srv/cvmfs ] && mv /srv/cvmfs /srv/cvmfs-save
ln -sf /mnt/resource/cvmfs /var/spool/cvmfs
ln -sf /mnt/resource/cvmfs_srv /srv/cvmfs

wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
dpkg -i cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb
apt-get update
apt-get install -y cvmfs cvmfs-server

systemctl stop autofs
systemctl disable autofs
