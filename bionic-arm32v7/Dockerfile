FROM arm32v7/ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  software-properties-common \
  gcc \
  g++ \
  binutils \
  build-essential \
  git \
  pkg-config \
  sudo \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  make \
  python3 \
  unzip

# Set python3 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN python --version

RUN mkdir -p /root/vscode
WORKDIR /root/vscode