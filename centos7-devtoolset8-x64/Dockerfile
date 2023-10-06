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
    krb5-devel \
    python3"

RUN yum install -y centos-release-scl-rh && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

# install nodejs
RUN yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
RUN yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1
RUN npm install -g yarn
RUN npm install -g node-gyp

ENV PATH=/opt/rh/devtoolset-8/root/usr/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# install cmake3
RUN git clone https://gitlab.kitware.com/cmake/cmake.git
RUN cd cmake && git checkout v3.26.0 && ./bootstrap --prefix=/usr/local -- -DCMAKE_USE_OPENSSL=OFF \
    make && make install

RUN mkdir -p /root/vscode
WORKDIR /root/vscode