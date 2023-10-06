ARG REPO=mcr.microsoft.com/mirror/docker/library/ubuntu
ARG TAG=18.04
FROM ${REPO}:${TAG}

ARG DEBIAN_FRONTEND=noninteractive

RUN groupadd --gid 1000 builduser \
  && useradd --uid 1000 --gid builduser --shell /bin/bash --create-home builduser

# ubuntu keeps its i386/amd64 and other architecture repos separate
# the default i386/amd64 packages can be found in http://archive.ubuntu.com while all other architectures are in http://ports.ubuntu.com/
# add the required repos for armhf/arm64 and only fetch i386/amd64 from archive.ubuntu.com (to prevent apt from erroring about missing architecture support)
RUN sed -i "s/^deb/deb [arch=amd64,i386]/g" /etc/apt/sources.list
RUN echo "deb [arch=arm64,armhf] http://ports.ubuntu.com/ bionic main universe multiverse restricted" | tee -a /etc/apt/sources.list
RUN echo "deb [arch=arm64,armhf] http://ports.ubuntu.com/ bionic-security main universe multiverse restricted" | tee -a /etc/apt/sources.list
RUN echo "deb [arch=arm64,armhf] http://ports.ubuntu.com/ bionic-updates main universe multiverse restricted" | tee -a /etc/apt/sources.list
RUN dpkg --add-architecture arm64
RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc-8-aarch64-linux-gnu \
  g++-8-aarch64-linux-gnu \
  binutils-aarch64-linux-gnu \
  build-essential \
  git \
  pkg-config \
  fakeroot \
  rpm \
  sudo \
  apt-transport-https \
  ca-certificates \
  libx11-dev:arm64 \
  libx11-xcb-dev:arm64 \
  libxkbfile-dev:arm64 \
  libsecret-1-dev:arm64 \
  libkrb5-dev:arm64 \
  curl \
  gnupg \
  unzip

# No Sudo Prompt
RUN echo 'builduser ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-builduser \
  && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

# Set python3 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN python --version

# Install docker client
RUN sudo mkdir -m 0755 -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get install -y docker-ce

# Node.js
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs
RUN npm install -g yarn
RUN npm install -g node-gyp

USER builduser
WORKDIR /home/builduser

ENV AS=/usr/bin/aarch64-linux-gnu-as \
  AR=/usr/bin/aarch64-linux-gnu-ar \
  CC=/usr/bin/aarch64-linux-gnu-gcc-8 \
  CPP=/usr/bin/aarch64-linux-gnu-cpp-8 \
  CXX=/usr/bin/aarch64-linux-gnu-g++-8 \
  LD=/usr/bin/aarch64-linux-gnu-ld \
  PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig