#!/bin/bash

_SIMG=ecpe4s-exawind-summit-2021-10-05.sif
[[ ! -f "${_SIMG}" && -z ${SIMG+x} ]] && wget "https://cache.e4s.io/exawind/artifacts/${_SIMG}"
SIMG=${SIMG:-$(pwd)/${_SIMG}}

_RUNDIR=${MEMBERWORK}/gen010/exawind-run
RUNDIR=${RUNDIR:-${_RUNDIR}}
[[ ! -d ${RUNDIR} ]] && mkdir -p ${RUNDIR}
cp inputs/ablNeutralNGPTrilinos.norm.gold \
 inputs/ablNeutralNGPTrilinos.yaml \
 inputs/abl_5km_5km_1km_neutral.g \
 inputs/milestone.xml \
 inputs/pass_fail.py ${RUNDIR}/

module load gcc/9.1.0
module unload darshan-runtime

MPI_HOST=${MPI_ROOT}
MPI_CONTAINER=${MPI_ROOT}

CUDA_HOST=/sw/summit/cuda/11.3.1
CUDA_CONTAINER=/sw/summit/cuda/11.3.1

NALUWIND_CMD_1="naluX -i ablNeutralNGPTrilinos.yaml"

set -x

jsrun \
 --nrs 6 \
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
    --bind /usr/lpp/mmfs/lib \
    --bind ${RUNDIR} \
    --bind ${HOME} \
    --bind ${MPI_HOST} \
    --bind ${CUDA_HOST} \
    --env LD_LIBRARY_PATH=${MPI_CONTAINER}/lib/pami_port:${MPI_CONTAINER}/lib:/usr/lpp/mmfs/lib \
    ${SIMG} /bin/bash -c "cd ${RUNDIR} && ${NALUWIND_CMD_1}"

(
 cd ${RUNDIR}
 ./pass_fail.py --abs-tol 1.0e-6 --rel-tol 1.0e-7 ablNeutralNGPTrilinos ablNeutralNGPTrilinos.norm.gold
)
