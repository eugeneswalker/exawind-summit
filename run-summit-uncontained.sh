#!/bin/bash

module load gcc/7.4.0
module unload darshan-runtime

RUNDIR=${RUNDIR:-${MEMBERWORK}/gen010/exawind-run}
AMRWIND_CMD="amr_wind $(pwd)/amr-wind.input amr.n_cell=384 512 512 geometry.prob_hi=300.0 400.0 400.0 time.max_step=10"

. ${MEMBERWORK}/gen010/exawind/spack/share/spack/setup-env.sh

spack load amr-wind

cd ${RUNDIR}

set -x

jsrun \
 --nrs 12 \
 --rs_per_host 6 \
 --tasks_per_rs 1 \
 --cpu_per_rs 1 \
 --gpu_per_rs 1 \
   ${AMRWIND_CMD}
