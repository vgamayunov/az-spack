#!/bin/bash
#SBATCH -p hbv4
#SBATCH -N 2
#SBATCH --ntasks-per-node=1

. /cvmfs/ape.core/1.0.1/setenv.sh
spack load intel-mpi-benchmarks%intel^openmpi

np=$((SLURM_JOB_NUM_NODES * SLURM_TASKS_PER_NODE))
mpirun IMB-MPI1 Allreduce -npmin $np
