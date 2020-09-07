FROM debian:buster

RUN dpkg --add-architecture arm64
RUN apt-get update && apt-get install -y --no-install-recommends \
  crossbuild-essential-arm64 \
  python \
  git \
  pkg-config \
  libx11-dev:arm64 \
  libx11-xcb-dev:arm64 \
  libxkbfile-dev:arm64 \
  libsecret-1-dev:arm64 \
  curl \
  ca-certificates \
  wget \
  apt-transport-https

# Node
RUN curl -fsSLO --compressed https://nodejs.org/dist/v12.14.1/node-v12.14.1-linux-x64.tar.xz \
  && tar --strip-components=1 -xJf node-v12.14.1-linux-x64.tar.xz -C /usr/local --no-same-owner \
  && rm node-v12.14.1-linux-x64.tar.xz

# Yarn
RUN curl -fsSLO --compressed https://yarnpkg.com/downloads/1.22.5/yarn-v1.22.5.tar.gz \
  && tar --strip-components=1 -xzf yarn-v1.22.5.tar.gz -C /usr/local \
  && rm yarn-v1.22.5.tar.gz

ENV AS=/usr/bin/aarch64-linux-gnu-as \
  AR=/usr/bin/aarch64-linux-gnu-ar \
  CC=/usr/bin/aarch64-linux-gnu-gcc \
  CPP=/usr/bin/aarch64-linux-gnu-cpp \
  CXX=/usr/bin/aarch64-linux-gnu-g++ \
  LD=/usr/bin/aarch64-linux-gnu-ld \
  FC=/usr/bin/aarch64-linux-gnu-gfortran \
  PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig

ENV npm_config_arch arm64
ENV CHILD_CONCURRENCY 1

RUN mkdir -p /root/vscode
WORKDIR /root/vscode