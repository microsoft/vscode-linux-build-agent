FROM debian:stretch

RUN dpkg --add-architecture armhf
RUN apt-get update && apt-get install -y --no-install-recommends \
  crossbuild-essential-armhf \
  python \
  git \
  pkg-config \
  fakeroot \
  rpm \
  sudo \
  ca-certificates \
  libx11-dev:armhf \
  libx11-xcb-dev:armhf \
  libxkbfile-dev:armhf \
  libsecret-1-dev:armhf \
  unzip \
  wget \
  openssl \
  libssl-dev:armhf

ENV AS=/usr/bin/arm-linux-gnueabihf-as \
  AR=/usr/bin/arm-linux-gnueabihf-ar \
  CC=/usr/bin/arm-linux-gnueabihf-gcc \
  CPP=/usr/bin/arm-linux-gnueabihf-cpp \
  CXX=/usr/bin/arm-linux-gnueabihf-g++ \
  LD=/usr/bin/arm-linux-gnueabihf-ld \
  FC=/usr/bin/arm-linux-gnueabihf-gfortran \
  PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig

# Install latest curl for openSSL 1.1.x
# https://www.openssl.org/blog/blog/2021/09/13/LetsEncryptRootCertExpire/
WORKDIR /tmp
RUN wget https://github.com/curl/curl/releases/latest/download/curl-7.79.1.zip
RUN unzip curl-7.79.1.zip
WORKDIR /tmp/curl-7.79.1
RUN ./configure --prefix=/usr --with-openssl --host="x86_64-pc-linux-gnu"
RUN make
RUN make install