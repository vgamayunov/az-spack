# az-spack
Scripts to install Spack and CVMFS on Azure.
## CVMFS Server
Create a VM with attached data disk of 1TB or more with Ubuntu 20.04 or 22.04. Then run
```bash
cd cvmfs
./setup-datadisk.sh
./setup-server.sh
```

## Setting up CVMFS
After `setup-server.sh`, perform the following steps:
- run `cvmfs_server mkfs azure.spack`
- copy `/etc/cvmfs/keys/azure.spack.pub` to `cluster-init/files`. It will be required to set up clients.

## CVMFS Client
Run `setup-client.sh` to add the packages.

