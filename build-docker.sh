#!/bin/bash

#"exawind.tgz"
for f in \
 "numactl-libs-2.0.12-11.el8.ppc64le.rpm" \
 "tcsh-6.20.00-13.el8.ppc64le.rpm" \
 "MLNX_OFED_LINUX-4.9-2.2.4.0-rhel8.2-ppc64le.tgz"
do
 [[ ! -f ${f} ]] && wget https://cache.e4s.io/exawind/artifacts/${f}
done

REGISTRY=${REGISTRY:-ecpe4s}
BUILD_DATE=$(printf '%(%Y-%m-%d)T' -1)
BUILD_TAG=${BUILD_TAG:-${BUILD_DATE}}

 docker build \
 -t "${REGISTRY}/exawind-summit:${BUILD_TAG}" .
