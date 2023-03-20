ARG REPO=mcr.microsoft.com/mirror/docker/library/centos
ARG TAG=7
FROM ${REPO}:${TAG}

ARG INSTALL_PKGS="devtoolset-8-gcc \
    devtoolset-8-gcc-c++ \
    devtoolset-8-gcc-gfortran \
    devtoolset-8-gdb \
    make \
    git \
    unzip \
    sudo \
    libsecret-devel \
    nodejs \
    python3"

# setup nodejs repo
RUN curl --silent --location https://rpm.nodesource.com/setup_16.x | bash -

RUN yum install -y centos-release-scl-rh && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

# update npm and install yarn
RUN npm install -g npm@latest
RUN npm install -g yarn

ENV PATH=/opt/rh/devtoolset-8/root/usr/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# install cmake3
RUN git clone https://gitlab.kitware.com/cmake/cmake.git
RUN cd cmake && git checkout v3.26.0 && ./bootstrap --prefix=/usr/local -- -DCMAKE_USE_OPENSSL=OFF \
    make && make install

RUN mkdir -p /root/vscode
WORKDIR /root/vscode