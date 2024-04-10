#!/bin/bash
set -euo pipefail

wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
sudo dpkg -i cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb
sudo apt-get update
sudo apt-get install -y cvmfs cvmfs-server

mkdir -pv /mnt/resource/cvmfs_srv
ln -sf /mnt/resource/cvmfs_srv /srv/cvmfs

systemctl stop autofs
systemctl disable autofs
