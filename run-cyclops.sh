#!/bin/bash

module load spectrummpi

MPI_HOST=/opt/ibm/spectrum_mpi
MPI_CONTAINER=/autofs/nccs-svm1_sw/summit/.swci/1-compute/opt/spack/20180914/linux-rhel7-ppc64le/gcc-7.4.0/spectrum-mpi-10.3.1.2-20200121-eu2wh5ypz6ipvokwbng2m5ihug6doysh

CUDA_HOST=/usr/local/packages/cuda/10.2
CUDA_CONTAINER=/sw/summit/cuda/10.2.89

SIMG=${HOME}/exawind-summit-2021-07-27.sif
RUNDIR=$(pwd)
AMRWIND_CMD="amr_wind $(pwd)/amr-wind.input amr.n_cell=200 200 200 geometry.prob_hi=156.25 156.25 156.25"

set -x

mpirun -np 4 \
 singularity run \
  --nv \
  --bind ${HOME}:${HOME} \
  --bind ${MPI_HOST}:${MPI_HOST} \
  --bind ${MPI_HOST}:${MPI_CONTAINER} \
  --bind ${CUDA_HOST}:${CUDA_CONTAINER} \
  --env LD_LIBRARY_PATH=${MPI_HOST}/lib/pami_port \
  ${SIMG} /bin/bash -c "cd ${RUNDIR} && ${AMRWIND_CMD}"
