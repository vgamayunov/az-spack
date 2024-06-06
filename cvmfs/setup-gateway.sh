#!/bin/bash
set -euo pipefail

if ! dpkg -l cvmfs-server ; then
  echo "Please install CVMFS server before running this script"
  exit 1
fi

apt-get update
apt-get install -y cvmfs-gateway

cat > /etc/cvmfs/gateway/user.json <<EOF
{
    "max_lease_time" : 7200,
    "port" : 4929,
    "num_receivers": 1,
    "receiver_path": "/usr/bin/cvmfs_receiver",
    "log_level" : "info",
    "log_timestamps" : false,
    "work_dir": "/var/lib/cvmfs-gateway"
}
EOF

systemctl restart cvmfs-gateway.service