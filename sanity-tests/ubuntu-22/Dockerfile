ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

# Use Azure package mirrors
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
		sed -i 's|http://archive.ubuntu.com|http://azure.archive.ubuntu.com|g' /etc/apt/sources.list; \
	else \
		sed -i 's|http://ports.ubuntu.com|http://azure.ports.ubuntu.com|g' /etc/apt/sources.list; \
	fi

# Utilities
RUN apt-get update && \
	apt-get install -y curl iproute2

# Node.js (arm32 uses official tarball since NodeSource dropped armhf support)
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "arm" ]; then \
		apt-get install -y libatomic1 && \
		curl -fsSL https://nodejs.org/dist/v20.18.3/node-v20.18.3-linux-armv7l.tar.gz | tar -xz -C /usr/local --strip-components=1; \
	else \
		curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
		apt-get install -y nodejs; \
	fi

# X11 Server
RUN apt-get install -y xvfb

# Desktop Bus
RUN apt-get install -y dbus-x11 && \
	mkdir -p /run/dbus

# VS Code dependencies
RUN apt-get install -y libasound2 || apt-get install -y libasound2t64 && \
	apt-get install -y libgtk-3-0 || apt-get install -y libgtk-3-0t64 && \
	apt-get install -y libcurl4 || apt-get install -y libcurl4t64 && \
	apt-get install -y \
	libgbm1 \
	libnss3 \
	xdg-utils
