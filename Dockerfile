FROM redhat/ubi8:8.2-299.1594117625

RUN yum install -y \
    autoconf \
    automake \
    bzip2 \
    curl \
    file \
    findutils \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    gettext \
    git \
    hostname \
    iputils \
    jq \
    libffi-devel \
    m4 \
    make \
    ncurses-devel \
    patch \
    pciutils \
    procps \
    python3-devel \
    unzip \
    vim \
    wget \
    which \
    xz \
    && ln -s `which python3` /usr/bin/python

RUN python3 -m pip install --upgrade pip setuptools wheel \
 && python3 -m pip install gnureadline boto3 pyyaml pytz minio requests clingo \
 && rm -rf ~/.cache

CMD ["/bin/bash"]

ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility

RUN mkdir -p /gpfs/alpine/scratch/lpeyrala/gen010 \
 && mkdir -p /gpfs/alpine/gen010/scratch/ \
 && ln -s /gpfs/alpine/scratch/lpeyrala/gen010 /gpfs/alpine/gen010/scratch/lpeyrala

COPY exawind.tgz /gpfs/alpine/scratch/lpeyrala/gen010/

WORKDIR /gpfs/alpine/scratch/lpeyrala/gen010

RUN tar xzf exawind.tgz \
 && rm -f exawind.tgz \
 && ln -s /gpfs/alpine/scratch/lpeyrala/gen010/exawind /exawind

WORKDIR /

RUN . /exawind/spack/share/spack/setup-env.sh \
 && spack mirror rm E4S \
 && spack mirror add E4S https://cache.e4s.io/exawind \
 && spack buildcache keys -it \
 && spack install --cache-only gcc@9.1.0+strip target=power9le \
 && spack mirror rm E4S \
 && spack compiler add $(spack location -i gcc) \
 && spack clean -a

RUN echo . /exawind/spack/share/spack/setup-env.sh >> /etc/bashrc \
 && echo spack load amr-wind >> /etc/bashrc \
 && echo spack load nalu-wind >> /etc/bashrc

COPY numactl-libs-2.0.12-11.el8.ppc64le.rpm tcsh-6.20.00-13.el8.ppc64le.rpm /

RUN yum -y install lsof ethtool tk tcl libmnl libevent-devel \
 && rpm -i numactl-libs-2.0.12-11.el8.ppc64le.rpm \
 && rpm -i tcsh-6.20.00-13.el8.ppc64le.rpm \
 && rm -f /*.rpm

COPY MLNX_OFED_LINUX-4.9-2.2.4.0-rhel8.2-ppc64le.tgz /

RUN tar xzf MLNX_OFED_LINUX-4.9-2.2.4.0-rhel8.2-ppc64le.tgz \
 && cd MLNX_OFED_LINUX-4.9-2.2.4.0-rhel8.2-ppc64le \
 && ./mlnxofedinstall --user-space-only --without-fw-update -q \
 && rm -rf /MLNX_OFED_LINUX-4.9-2.2.4.0-rhel8.2-ppc64le

WORKDIR /
