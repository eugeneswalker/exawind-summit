#!/bin/bash

set -e

module load gcc/9.3.0
module load spectrum-mpi/10.4.0.3-20210112
module load cuda/11.3.1

set -x

export MPI_IGNORE_PBS=on
export CUDA_LAUNCH_BLOCKING=1
SPACK=/gpfs/alpine/proj-shared/gen010/exawind/spack/bin/spack

EXAWIND=$(${SPACK} location -i exawind~amr_wind_gpu~nalu_wind_gpu)
jsrun --nrs 2 --rs_per_host 2 --cpu_per_rs 1 --gpu_per_rs 1 ${EXAWIND}/bin/exawind --awind 1 --nwind 1 exwsim.yaml &> cpu-cpu.txt
mkdir cpu-cpu
mv plt* memusage.dat *.log overset cpu-cpu.txt cpu-cpu/

EXAWIND=$(${SPACK} location -i exawind+amr_wind_gpu~nalu_wind_gpu)
jsrun --nrs 2 --rs_per_host 2 --cpu_per_rs 1 --gpu_per_rs 1 ${EXAWIND}/bin/exawind --awind 1 --nwind 1 exwsim.yaml &> gpu-cpu.txt
mkdir gpu-cpu
mv plt* memusage.dat *.log overset gpu-cpu.txt gpu-cpu/

EXAWIND=$(${SPACK} location -i exawind+amr_wind_gpu+nalu_wind_gpu)
jsrun --nrs 2 --rs_per_host 2 --cpu_per_rs 1 --gpu_per_rs 1 ${EXAWIND}/bin/exawind --awind 1 --nwind 1 exwsim.yaml &> gpu-gpu.txt
mkdir gpu-gpu
mv plt* memusage.dat *.log overset gpu-gpu.txt gpu-gpu/
