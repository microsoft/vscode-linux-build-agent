ARG REPO=ubuntu
ARG TAG=18.04
FROM ${REPO}:${TAG}

# ubuntu keeps its i386/amd64 and other architecture repos separate
# the default i386/amd64 packages can be found in http://archive.ubuntu.com while all other architectures are in http://ports.ubuntu.com/
# add the required repos for armhf/arm64 and only fetch i386/amd64 from archive.ubuntu.com (to prevent apt from erroring about missing architecture support)
RUN sed -i "s/^deb/deb [arch=amd64,i386]/g" /etc/apt/sources.list
RUN echo "deb [arch=arm64,armhf] http://ports.ubuntu.com/ bionic main universe multiverse restricted" | tee -a /etc/apt/sources.list
RUN echo "deb [arch=arm64,armhf] http://ports.ubuntu.com/ bionic-security main universe multiverse restricted" | tee -a /etc/apt/sources.list
RUN echo "deb [arch=arm64,armhf] http://ports.ubuntu.com/ bionic-updates main universe multiverse restricted" | tee -a /etc/apt/sources.list
RUN dpkg --add-architecture armhf
RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc-8-arm-linux-gnueabihf g++-8-arm-linux-gnueabihf gfortran-8-arm-linux-gnueabihf binutils-arm-linux-gnueabihf \
  git \
  pkg-config \
  fakeroot \
  rpm \
  sudo \
  apt-transport-https \
  ca-certificates \
  libx11-dev:armhf \
  libx11-xcb-dev:armhf \
  libxkbfile-dev:armhf \
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

# Compile python3.9 from source
RUN curl -O https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tar.xz
RUN tar -xf Python-3.9.4.tar.xz
RUN cd Python-3.9.4 && ./configure --enable-optimizations && make altinstall
RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python3.9 1
RUN python --version

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
  CC=/usr/bin/arm-linux-gnueabihf-gcc-8 \
  CPP=/usr/bin/arm-linux-gnueabihf-cpp-8 \
  CXX=/usr/bin/arm-linux-gnueabihf-g++-8 \
  LD=/usr/bin/arm-linux-gnueabihf-ld \
  FC=/usr/bin/arm-linux-gnueabihf-gfortran-8 \
  PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig