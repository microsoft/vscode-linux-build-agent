FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN groupadd --gid 1000 builduser \
  && useradd --uid 1000 --gid builduser --shell /bin/bash --create-home builduser \
  && mkdir -p /setup

# Set up TEMP directory
ENV TEMP=/tmp
RUN chmod a+rwx /tmp

# Core environment variables
ENV DBUS_SESSION_BUS_ADDRESS="autolaunch:" \
	LANG="en_US.UTF-8" \
	LANGUAGE="en_US.UTF-8" \
	VISUAL="nano" \
	EDITOR="nano"

# Latest stable git
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:git-core/ppa -y

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    createrepo \
    curl \
    g++-multilib \
    gcc-5 \
    g++-5 \
    git \
    gnome-keyring \
    iproute2 \
    jq \
    libatk-bridge2.0-0 \
    libfuse2 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libgl1 \
    libgtk-3.0 \
    libnotify-bin \
    libsecret-1-dev \
    libssl-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxkbfile-dev \
    locales \
    lsb-release \
    lsof \
    policykit-1 \
    python-dbus \
    python-gtk2 \
    python-pip \
    sudo \
    wget \
    xvfb \
    yarn \
    tzdata \
    unzip \
  && curl https://chromium.googlesource.com/chromium/src/+/HEAD/build/install-build-deps.sh\?format\=TEXT | base64 --decode | cat > /setup/install-build-deps.sh \
  && chmod +x /setup/install-build-deps.sh \
  && bash /setup/install-build-deps.sh --syms --no-prompt --no-chromeos-fonts --no-arm --no-nacl \
  && rm -rf /var/lib/apt/lists/*

# Install older gcc toolchain from Xenial
RUN echo "deb http://dk.archive.ubuntu.com/ubuntu/ xenial main"  | tee -a /etc/apt/sources.list
RUN echo "deb http://dk.archive.ubuntu.com/ubuntu/ xenial universe" | tee -a /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    gcc-4.9 \
    g++-4.9 \
    gcc-4.8 \
    g++-4.8

# No Sudo Prompt
RUN echo 'builduser ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-builduser \
  && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

# Dotnet
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y dotnet-sdk-2.1

COPY init-dbus.sh /usr/local/share/

# Update privs, owners of config files
RUN mkdir -p /var/run/dbus \
	&& chmod +x /usr/local/share/init-dbus.sh

USER builduser
WORKDIR /home/builduser

ENTRYPOINT ["/usr/local/share/init-dbus.sh"]