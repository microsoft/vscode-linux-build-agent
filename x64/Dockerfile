FROM ubuntu:14.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  gcc-multilib g++-multilib \
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
  libfuse2 \
  libnotify-bin \
  libx11-dev \
  libxss1 \
  libx11-xcb-dev \
  libxkbfile-dev \
  bc bsdmainutils \
  libsecret-1-dev \
  curl \
  ca-certificates

# Xvfb
# Thanks https://medium.com/@griggheo/running-headless-selenium-webdriver-tests-in-docker-containers-342fdbabf756
ADD xvfb.init /etc/init.d/xvfb
RUN chmod +x /etc/init.d/xvfb
RUN update-rc.d xvfb defaults

# dbus
RUN ln -sf /bin/dbus-daemon /usr/bin/dbus-daemon