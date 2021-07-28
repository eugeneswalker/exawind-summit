#!/bin/bash

module load gcc/7.4.0
module unload darshan-runtime

MPI_HOST=${MPI_ROOT}
MPI_CONTAINER=${MPI_ROOT}

CUDA_HOST=/sw/summit/cuda/10.2.89
CUDA_CONTAINER=/sw/summit/cuda/10.2.89

SIMG=${HOME}/exawind-summit-2021-07-27.sif
RUNDIR=${MEMBERWORK}/gen010/exawind-run
AMRWIND_CMD="amr_wind $(pwd)/amr-wind.input amr.n_cell=200 200 200 geometry.prob_hi=156.25 156.25 156.25"

set -x

jsrun -n8 -r4 -a1 -c1 -g1 \
 singularity run \
  --nv \
  --bind ${MEMBERWORK}:${MEMBERWORK} \
  --bind ${HOME}:${HOME} \
  --bind ${MPI_HOST}:${MPI_CONTAINER} \
  --bind ${CUDA_HOST}:${CUDA_CONTAINER} \
  --env LD_LIBRARY_PATH=${MPI_CONTAINER}/lib/pami_port \
  ${SIMG} /bin/bash -c "cd ${RUNDIR} && ${AMRWIND_CMD}"
