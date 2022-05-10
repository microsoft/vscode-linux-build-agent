FROM multiarch/ubuntu-core:arm64-xenial

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  # gcc-multilib \
  # g++-multilib \
  git \
  # dpkg-dev \
  zip \
  # rpm \
  # createrepo \
  python-gtk2 \
  jq \
  # xvfb \
  # fakeroot \
  libgtk2.0-0 \
  libgconf-2-4 \
  libnss3 \
  libasound2 \
  libxtst6 \
  libfuse2 \
  libnotify-bin \
  libx11-dev \
  libxss1 \
  libx11-xcb-dev \
  libxkbfile-dev \
  bc \
  bsdmainutils \
  libsecret-1-dev \
  pkg-config \
  libgtk-3-0 \
  curl \
  ca-certificates \
  wget \
  apt-transport-https \
  unzip

# Node
RUN curl -fsSLO --compressed https://nodejs.org/dist/v10.11.0/node-v10.11.0-linux-arm64.tar.xz
RUN tar --strip-components=1 -xJf node-v10.11.0-linux-arm64.tar.xz -C /usr/local --no-same-owner
RUN rm node-v10.11.0-linux-arm64.tar.xz

# Yarn
RUN curl -fsSLO --compressed https://yarnpkg.com/downloads/1.10.1/yarn-v1.10.1.tar.gz
RUN tar --strip-components=1 -xzf yarn-v1.10.1.tar.gz -C /usr/local
RUN rm yarn-v1.10.1.tar.gz

RUN mkdir -p /root/vscode
WORKDIR /root/vscode