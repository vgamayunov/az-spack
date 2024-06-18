#!/bin/bash
set -euo pipefail
REPOS="ape.core"

for REPONAME in $REPOS ; do

    if [ -d /cvmfs/$REPONAME ] ; then
        echo WARNING: CVMFS repo $REPONAME already exists.
        break
    fi

    if [ ! -f /etc/cvmfs/gateway/user.json ] ; then
        echo CVMFS gateway is not set up. Please configure the gateway before setting up APE
        exit 1
    fi

    # Create new filesystem
    cvmfs_server mkfs -o hpcadmin $REPONAME

    # Generate password for publishers
    password=$(openssl rand -hex 12)

    echo "plain_text ape_key $password" > /etc/cvmfs/keys/$REPONAME.gw

done

repolist=""
for r in $REPOS ; do
    if [ "$repolist" != "" ] ; then
        repolist="$repolist,"
    fi
    repolist="$repolist \"$r\""
done

cat > /etc/cvmfs/gateway/repo.json <<EOF
{
    "version": 2,
    "repos" : [ $repolist ]
}
EOF


systemctl restart cvmfs-gateway.service
