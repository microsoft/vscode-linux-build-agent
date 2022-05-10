FROM debian:buster

RUN dpkg --add-architecture arm64
RUN apt-get update && apt-get install -y --no-install-recommends \
  crossbuild-essential-arm64 \
  python \
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
  curl \
  gnupg \
  wget \
  unzip

# Yarn
RUN wget -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

ENV AS=/usr/bin/aarch64-linux-gnu-as \
  AR=/usr/bin/aarch64-linux-gnu-ar \
  CC=/usr/bin/aarch64-linux-gnu-gcc \
  CPP=/usr/bin/aarch64-linux-gnu-cpp \
  CXX=/usr/bin/aarch64-linux-gnu-g++ \
  LD=/usr/bin/aarch64-linux-gnu-ld \
  FC=/usr/bin/aarch64-linux-gnu-gfortran \
  PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig