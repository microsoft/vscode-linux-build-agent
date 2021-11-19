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
  curl \
  gnupg \
  unzip

# Remove expired CA cert for openSSL 1.0.2
# https://www.openssl.org/blog/blog/2021/09/13/LetsEncryptRootCertExpire/
RUN rm -f /usr/share/ca-certificates/mozilla/DST_Root_CA_X3.crt
RUN update-ca-certificates --fresh

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

ENV AS=/usr/bin/arm-linux-gnueabihf-as \
  AR=/usr/bin/arm-linux-gnueabihf-ar \
  CC=/usr/bin/arm-linux-gnueabihf-gcc \
  CPP=/usr/bin/arm-linux-gnueabihf-cpp \
  CXX=/usr/bin/arm-linux-gnueabihf-g++ \
  LD=/usr/bin/arm-linux-gnueabihf-ld \
  FC=/usr/bin/arm-linux-gnueabihf-gfortran \
  PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig