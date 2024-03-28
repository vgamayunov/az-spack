#!/bin/bash

. spack/share/spack/setup-env.sh

spack install hpcx-mpi
spack install hcoll
spack install ucx
spack install ucc
