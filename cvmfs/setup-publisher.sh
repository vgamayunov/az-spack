#!/bin/bash
set -euo pipefail


wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
sudo dpkg -i cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb
sudo apt-get update
sudo apt-get install -y cvmfs cvmfs-server

exit 1

mkdir -pv /mnt/resource/cvmfs_srv
ln -sf /mnt/resource/cvmfs_srv /srv/cvmfs

systemctl stop autofs

cp azure.pe.crt /etc/cvmfs/keys
cp azure.pe.gw /etc/cvmfs/keys

cvmfs_server mkfs -w http://cvmfsserver/cvmfs/azure.pe -u gw,/srv/cvmfs/azure.pe/data/txn,http://cvmfsserver:4929/api/v1 -k /etc/cvmfs/keys -o root azure.pe

