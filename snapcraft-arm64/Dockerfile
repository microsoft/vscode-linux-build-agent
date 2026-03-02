ARG RISK=stable
ARG REPO=mcr.microsoft.com/mirror/docker/library/ubuntu
ARG TAG=22.04

FROM --platform=linux/arm64/v8 ${REPO}:${TAG} AS builder
ARG RISK
ARG REPO
ARG TAG
RUN echo "Building snapcraft:$RISK in $REPO:$TAG"

# Grab dependencies
RUN apt-get update
RUN apt-get dist-upgrade --yes
RUN apt-get install --yes \
      curl \
      jq \
      squashfs-tools \
      git \
      build-essential \
      libkrb5-dev \
      autoconf \
      python3-pip

# Grab the core22 snap from the stable channel and unpack it in the proper place.
RUN curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core22?architecture=arm64' | jq '.download_url' -r) --output core22.snap
RUN mkdir -p /snap/core22
RUN unsquashfs -d /snap/core22/current core22.snap

# Grab the core24 snap (needed by snapcraft 8.x runtime) from the stable channel and unpack it in the proper place.
RUN curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core24?architecture=arm64' | jq '.download_url' -r) --output core24.snap
RUN mkdir -p /snap/core24
RUN unsquashfs -d /snap/core24/current core24.snap

# Grab the snapcraft snap from the $RISK channel and unpack it in the proper place.
RUN curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/snapcraft?channel='$RISK'&architecture=arm64' | jq '.download_url' -r) --output snapcraft.snap
RUN mkdir -p /snap/snapcraft
RUN unsquashfs -d /snap/snapcraft/current snapcraft.snap

# Embed python dependencies in the snapcraft snap.
RUN ln -sf python3.12 /snap/snapcraft/current/usr/bin/python3
RUN echo /snap/snapcraft/current/lib/python3.*/site-packages >> /snap/snapcraft/current/usr/lib/python3/dist-packages/site-packages.pth
RUN pip3 install -U setuptools --target="$(ls -d /snap/snapcraft/current/lib/python3.*/site-packages)"

# Create a snapcraft runner (TODO: move version detection to the core of snapcraft).
RUN mkdir -p /snap/bin
RUN echo "#!/bin/sh" > /snap/bin/snapcraft
RUN snap_version="$(awk '/^version:/{print $2}' /snap/snapcraft/current/meta/snap.yaml | tr -d \')" && echo "export SNAP_VERSION=\"$snap_version\"" >> /snap/bin/snapcraft
RUN echo 'exec "$SNAP/bin/python" "$SNAP/bin/snapcraft" "$@"' >> /snap/bin/snapcraft
RUN chmod +x /snap/bin/snapcraft

# Build patchelf
RUN git clone https://github.com/NixOS/patchelf
RUN cd patchelf && ./bootstrap.sh && ./configure && make && cp ./src/patchelf /snap/bin/patchelf

# Multi-stage build, only need the snaps from the builder. Copy them one at a time so they can be cached.
FROM --platform=linux/arm64/v8 ${REPO}:${TAG}
COPY --from=builder /snap/core22 /snap/core22
COPY --from=builder /snap/core24 /snap/core24
COPY --from=builder /snap/snapcraft /snap/snapcraft
COPY --from=builder /snap/bin/snapcraft /snap/bin/snapcraft
COPY --from=builder /snap/bin/patchelf /snap/bin/patchelf

# Generate locale and install dependencies.
RUN apt-get update && apt-get install --yes snapd sudo locales && locale-gen en_US.UTF-8

# Set the proper environment.
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"
ENV SNAP="/snap/snapcraft/current"
ENV SNAP_NAME="snapcraft"
ENV SNAP_ARCH="arm64"
ENV PATH="/snap/bin:/snap/snapcraft/current/usr/bin:$PATH"
