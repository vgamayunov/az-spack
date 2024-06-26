#!/bin/bash
SERVER=${1:-cvmfsserver}
REPO=ape.core

wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
sudo dpkg -i cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb
sudo apt-get update
sudo apt-get install -y cvmfs

sudo tee /etc/cvmfs/default.local <<EOF
CVMFS_SERVER_URL=http://$SERVER/cvmfs/$REPO
CVMFS_HTTP_PROXY=DIRECT
CVMFS_PUBLIC_KEY=/etc/cvmfs/keys/$REPO.pub
CVMFS_CACHE_BASE=/mnt/resource/cvmfs
EOF

sudo tee /etc/cvmfs/config.d/$REPO.conf <<EOF
CVMFS_SERVER_URL=http://$SERVER/cvmfs/$REPO
CVMFS_PUBLIC_KEY=/etc/cvmfs/keys/$REPO.pub
EOF

sudo tee /etc/cvmfs/keys/$REPO.pub <<EOF
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAk5qiU/1ORTFOayQo8jUz
3tvYlLKJxKuzIWwANaAgYQGV0gNUmVRV2yXuxS6Oz60kp+O4S97brN5MZY6MH2DC
WrwDy8AEFWlmXKXkV/9Rgu/bGSpOaw+L0IsGfFeGPkc1MSyw0oBbPfVb3k64m5d9
GYv+A1B/EywCbj8+mmflVLbnDdcwujR9s7MMdYAvnCU9j99zWuVGasKHNzqcPITG
oXHKVjbhC7RE044+uZibFYyGPksCB6GyZqgp23FaFHHfblwRVm788cJzp8t0sCCK
DZjhjWGdqrFqtpw3N35mTqRKsciye7PkxBcDZNd+QSZw2AiTMCHklYOCCFe6ADAE
vQIDAQAB
-----END PUBLIC KEY-----
EOF

sudo cvmfs_config setup

