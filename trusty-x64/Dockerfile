FROM ubuntu:14.04

ARG DEBIAN_FRONTEND=noninteractive

# Latest stable git
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:git-core/ppa -y

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  gcc-multilib \
  g++-multilib \
  git \
  dpkg-dev \
  zip \
  rpm \
  createrepo \
  python-gtk2 \
  jq \
  xvfb \
  fakeroot \
  libgtk2.0-0 \
  libgconf-2-4 \
  libnss3 \
  libasound2 \
  libxtst6 \
  libgbm1 \
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
  libssl-dev \
  psmisc \
  unzip

# Dotnet
RUN wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y dotnet-sdk-2.1

# Xvfb
# Thanks https://medium.com/@griggheo/running-headless-selenium-webdriver-tests-in-docker-containers-342fdbabf756
ADD xvfb.init /etc/init.d/xvfb
RUN chmod +x /etc/init.d/xvfb
RUN update-rc.d xvfb defaults

# dbus
RUN ln -sf /bin/dbus-daemon /usr/bin/dbus-daemon