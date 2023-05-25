ARG REPO=debian
ARG TAG=stretch
FROM ${REPO}:${TAG}

RUN dpkg --add-architecture armhf

RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list 
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
  crossbuild-essential-armhf \
  git \
  pkg-config \
  sudo \
  apt-transport-https \
  ca-certificates \
  libsecret-1-dev:armhf \
  curl \
  gnupg \
  unzip \
  # Dependencies for building python from source
  build-essential \
  libreadline-gplv2-dev \
  libncursesw5-dev \
  libssl-dev \
  libsqlite3-dev \
  tk-dev \
  libgbm-dev \
  libc6-dev \
  libbz2-dev \
  libffi-dev \
  zlib1g-dev

# Remove expired CA cert for openSSL 1.0.2
# https://www.openssl.org/blog/blog/2021/09/13/LetsEncryptRootCertExpire/
RUN rm -f /usr/share/ca-certificates/mozilla/DST_Root_CA_X3.crt
RUN update-ca-certificates --fresh

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
Run sudo apt-get install -y nodejs
RUN node --version

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Compile python3.9 from source
RUN curl -O https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tar.xz
RUN tar -xf Python-3.9.4.tar.xz
RUN cd Python-3.9.4 && ./configure --enable-optimizations && make altinstall
RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python3.9 1
RUN python --version

ENV AS=/usr/bin/arm-linux-gnueabihf-as \
  AR=/usr/bin/arm-linux-gnueabihf-ar \
  CC=/usr/bin/arm-linux-gnueabihf-gcc \
  CPP=/usr/bin/arm-linux-gnueabihf-cpp \
  CXX=/usr/bin/arm-linux-gnueabihf-g++ \
  LD=/usr/bin/arm-linux-gnueabihf-ld \
  FC=/usr/bin/arm-linux-gnueabihf-gfortran \
  PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig

RUN mkdir -p /root/vscode
WORKDIR /root/vscode