#!/bin/bash

./download-docker-requirements.sh

for f in \
 "numactl-libs-2.0.12-11.el8.ppc64le.rpm" \
 "tcsh-6.20.00-13.el8.ppc64le.rpm" \
 "MLNX_OFED_LINUX-4.9-2.2.4.0-rhel8.2-ppc64le.tgz" \
 "exawind.tgz"
do
 [[ ! -f ${f} ]] && wget https://cache.e4s.io/exawind/artifacts/${f}
done

docker build -t ecpe4s/exawind-summit:2021-10-05 .
