FROM debian:stretch

RUN dpkg --add-architecture arm64
RUN apt-get update && apt-get install -y --no-install-recommends \
  crossbuild-essential-arm64 \
  python \
  git \
  pkg-config \
  fakeroot \
  rpm \
  sudo \
  ca-certificates \
  libx11-dev:arm64 \
  libx11-xcb-dev:arm64 \
  libxkbfile-dev:arm64 \
  libsecret-1-dev:arm64 \
  unzip \
  wget \
  openssl \
  libssl-dev:arm64

ENV AS=/usr/bin/aarch64-linux-gnu-as \
  AR=/usr/bin/aarch64-linux-gnu-ar \
  CC=/usr/bin/aarch64-linux-gnu-gcc \
  CPP=/usr/bin/aarch64-linux-gnu-cpp \
  CXX=/usr/bin/aarch64-linux-gnu-g++ \
  LD=/usr/bin/aarch64-linux-gnu-ld \
  FC=/usr/bin/aarch64-linux-gnu-gfortran \
  PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig

# Install latest curl for openSSL 1.1.x
# https://www.openssl.org/blog/blog/2021/09/13/LetsEncryptRootCertExpire/
WORKDIR /tmp
RUN wget https://github.com/curl/curl/releases/latest/download/curl-7.79.1.zip
RUN unzip curl-7.79.1.zip
WORKDIR /tmp/curl-7.79.1
RUN ./configure --prefix=/usr --with-openssl --host="aarch64-linux-gnu"
RUN make
RUN make install