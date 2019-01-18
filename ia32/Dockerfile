FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386

RUN apt-get update

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  gcc-multilib \
  g++-multilib \
  git \
  dpkg-dev:i386 \
  zip \
  rpm \
  createrepo \
  python-gtk2 \
  jq \
  xvfb \
  fakeroot \
  libgtk2.0-0:i386 \
  libgconf-2-4:i386 \
  libnss3:i386 \
  libasound2:i386 \
  libxtst6:i386 \
  libfuse2 \
  libnotify-bin \
  libnotify4:i386 \
  libx11-dev:i386 \
  libxss1:i386 \
  libx11-xcb-dev:i386 \
  libxkbfile-dev:i386 \
  libxkbfile-dev \
  libgl1-mesa-glx:i386 \
  libgl1-mesa-dri:i386 \
  libgtk-3-0:i386 \
  libgirepository-1.0-1:i386 \
  gir1.2-glib-2.0:i386 \
  gir1.2-secret-1:i386 \
  libsecret-1-dev:i386 \
  bc \
  bsdmainutils \
  pkg-config \
  curl \
  ca-certificates \
  wget \
  apt-transport-https

# Dotnet
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y dotnet-sdk-2.2

# Xvfb
# Thanks https://medium.com/@griggheo/running-headless-selenium-webdriver-tests-in-docker-containers-342fdbabf756
ADD xvfb.init /etc/init.d/xvfb
RUN chmod +x /etc/init.d/xvfb
RUN update-rc.d xvfb defaults

# dbus
RUN ln -sf /bin/dbus-daemon /usr/bin/dbus-daemon

# for libsecret
ENV PKG_CONFIG_PATH /usr/lib/i386-linux-gnu/pkgconfig