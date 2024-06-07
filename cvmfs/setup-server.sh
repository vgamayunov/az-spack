#!/bin/bash
set -euo pipefail

if [ ! -d /data0 ] ; then
  echo "Please add data disk (/data0) before installing cvmfs server"
  exit 1
fi

mkdir -pv /data0/{cvmfs,cvmfs-srv}
mkdir -pv /srv

[ -d /var/spool/cvmfs ] && mv /var/spool/cvmfs /var/spool/cvmfs-save
[ -d /srv/cvmfs ] && mv /srv/cvmfs /srv/cvmfs-save
ln -sf /data0/cvmfs /var/spool/cvmfs
ln -sf /data0/cvmfs-srv /srv/cvmfs


wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
sudo dpkg -i cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb
sudo apt-get update
sudo apt-get install -y cvmfs cvmfs-server
# sudo DEBIAN_FRONTEND=noninteractive apt-get install -y cvmfs cvmfs-server
