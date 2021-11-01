#!/bin/bash

_SIMG=ecpe4s-exawind-summit-2021-11-01.sif
[[ ! -f "${_SIMG}" && -z ${SIMG+x} ]] && wget "https://cache.e4s.io/exawind/artifacts/${_SIMG}"
SIMG=${SIMG:-$(pwd)/${_SIMG}}

_RUNDIR=${MEMBERWORK}/gen010/exawind-run
RUNDIR=${RUNDIR:-${_RUNDIR}}
[[ ! -d ${RUNDIR} ]] && mkdir -p ${RUNDIR}
cp -r nalu-amr ${RUNDIR}/

module load gcc/9.3.0
module load spectrum-mpi/10.4.0.3-20210112
module load cuda/11.3.1
module unload darshan-runtime

MPI_HOST=${MPI_ROOT}
MPI_CONTAINER=${MPI_ROOT}

CUDA_HOST=/sw/summit/cuda/11.3.1
CUDA_CONTAINER=/sw/summit/cuda/11.3.1

RUNDIR_HOST=${RUNDIR}
RUNDIR_CONTAINER=/rundir

EXAWIND_CMD_GPU_GPU="spack load exawind+amr_wind_gpu+nalu_wind_gpu && exawind --awind 1 --nwind 1 exwsim.yaml"

set -x

export MPI_IGNORE_PBS=on
export CUDA_LAUNCH_BLOCKING=1

jsrun \
 --nrs 2 \
 --rs_per_host 2 \
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
    --bind ${RUNDIR_HOST}:${RUNDIR_CONTAINER} \
    --bind ${HOME} \
    --bind ${MPI_HOST} \
    --bind ${CUDA_HOST} \
    --env LD_LIBRARY_PATH=${MPI_CONTAINER}/lib/pami_port \
    ${SIMG} /bin/bash -c "cd ${RUNDIR_CONTAINER} && ${EXAWIND_CMD_GPU_GPU}"

if [[ $? -eq 0 ]] ; then
  (
    cd ${RUNDIR_HOST}
    mkdir gpu-gpu
    mv plt* memusage.dat *.log overset gpu-gpu.txt gpu-gpu/
  )
fi
