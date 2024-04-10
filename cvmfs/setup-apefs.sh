#!/bin/bash
REPONAME=ape.core

if [ -d /cvmfs/$REPONAME ] ; then
    echo CVMFS repo $REPONAME already exists. Exiting...
    exit 0
fi

if [ ! -f /etc/cvmfs/gateway/user.json ] ; then
    echo CVMFS gateway is not set up. Please configure the gateway before setting up APE
    exit 1
fi

# Create new filesystem
cvmfs_server mkfs -o hpcadmin $REPONAME

cat > /etc/cvmfs/gateway/repo.json <<EOF
{
    "version": 2,
    "repos" : [
            "$REPONAME"
    ]
}
EOF

# Generate password for publishers
password=$(openssl rand -hex 12)

echo "plain_text ape_key $password" > /etc/cvmfs/keys/$REPONAME.gw

systemctl restart cvmfs-gateway.service
