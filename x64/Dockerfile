FROM ubuntu:14.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y --no-install-recommends \
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
  sudo \
  squashfs-tools

# Snapcraft
RUN curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core' | jq '.download_url' -r) --output core.snap && \
  mkdir -p /snap/core && unsquashfs -d /snap/core/current core.snap && rm core.snap && \
  curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/snapcraft?channel=stable' | jq '.download_url' -r) --output snapcraft.snap && \
  mkdir -p /snap/snapcraft && unsquashfs -d /snap/snapcraft/current snapcraft.snap && rm snapcraft.snap && \
  apt remove --yes --purge squashfs-tools && \
  apt-get autoclean --yes && \
  apt-get clean --yes

COPY bin/snapcraft-wrapper /snap/bin/snapcraft
ENV SNAP=/snap/snapcraft/current
ENV SNAP_NAME=snapcraft
ENV PATH=/snap/bin:$PATH

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