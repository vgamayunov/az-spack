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
- run `cvmfs_server mkfs your_repo_name`
- copy `/etc/cvmfs/keys/your_repo_name.pub` to `cluster-init/files`. It will be required to set up clients.

## CVMFS Client
Run `setup-client.sh` to add the packages.

## Spack
It is recommended to run each installer as a separate CVMFS transaction. Make sure each install script runs successfully. `run_all.sh` script will run through the following sequence:
```bash
install_spack.sh
install_externals.sh
install_compilers.sh
install_common.sh
install_system-libs.sh
install_openmpi.sh
```
