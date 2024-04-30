#!/bin/bash
. setenv.sh || exit 1

# GCC+HPCX
spack install --reuse netcdf-fortran %$SPACK_BASE_COMPILER target=$SPACK_BASE_TARGET ^hpcx-mpi

# Intel compilers + Open MPI
spack install --reuse netcdf-fortran target=$SPACK_BASE_TARGET %intel@2021.10.0 ^openmpi%intel fabrics=hcoll,knem,ucc,ucx schedulers=slurm \
  ^cmake%$SPACK_BASE_COMPILER ^gmake%$SPACK_BASE_COMPILER ^hdf5%intel ^netcdf-c%intel

# Intel compilers + Intel MPI
spack install --reuse netcdf-fortran target=$SPACK_BASE_TARGET %intel@2021.10.0 ^intel-oneapi-mpi \
  ^gmake%$SPACK_BASE_COMPILER ^hdf5%intel ^cmake%$SPACK_BASE_COMPILER ^netcdf-c%intel ^bzip2%$SPACK_BASE_COMPILER \
  ^c-blosc%$SPACK_BASE_COMPILER ^cmake%$SPACK_BASE_COMPILER
