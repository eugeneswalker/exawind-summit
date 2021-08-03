#!/bin/bash

module load gcc/7.4.0
module unload darshan-runtime

MPI_HOST=${MPI_ROOT}
MPI_CONTAINER=${MPI_ROOT}

CUDA_HOST=/sw/summit/cuda/10.2.89
CUDA_CONTAINER=/sw/summit/cuda/10.2.89

SIMG=${SIMG:-${HOME}/exawind-summit-2021-07-27.sif}
RUNDIR=${RUNDIR:-${MEMBERWORK}/gen010/exawind-run}
AMRWIND_CMD="amr_wind $(pwd)/amr-wind.input amr.n_cell=384 512 512 geometry.prob_hi=300.0 400.0 400.0 time.max_step=10"

set -x

jsrun \
 --nrs 12 \
 --rs_per_host 6 \
 --tasks_per_rs 1 \
 --cpu_per_rs 1 \
 --gpu_per_rs 1 \
   singularity run \
    --nv \
    --contain \
    --bind /tmp \
    --bind /dev \
    --bind /etc/localtime \
    --bind /etc/hosts \
    --bind /autofs/nccs-svm1_sw \
    --bind /ccs/sw \
    --bind /sw \
    --bind /autofs/nccs-svm1_proj \
    --bind /ccs/proj \
    --bind /sw/summitdev/singularity/98-OLCF.sh:/.singularity.d/env/98-OLCF.sh \
    --bind /etc/libibverbs.d \
    --bind /lib64:/host_lib64 \
    --bind ${RUNDIR} \
    --bind ${HOME} \
    --bind ${MPI_HOST} \
    --bind ${CUDA_HOST} \
    --env LD_LIBRARY_PATH=${MPI_CONTAINER}/lib/pami_port \
    ${SIMG} /bin/bash -c "cd ${RUNDIR} && ${AMRWIND_CMD}"
