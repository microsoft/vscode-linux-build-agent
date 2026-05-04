ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

# Use Azure package mirrors
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
		sed -i 's|http://archive.ubuntu.com|http://azure.archive.ubuntu.com|g' /etc/apt/sources.list.d/ubuntu.sources; \
	else \
		sed -i 's|http://ports.ubuntu.com|http://azure.ports.ubuntu.com|g' /etc/apt/sources.list.d/ubuntu.sources; \
	fi

# Utilities
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y curl iproute2

# Node.js (arm32 uses official tarball since NodeSource dropped armhf support)
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "arm" ]; then \
		apt-get install -y libatomic1 && \
		curl -fsSL https://nodejs.org/dist/v22.22.2/node-v22.22.2-linux-armv7l.tar.gz | tar -xz -C /usr/local --strip-components=1; \
	else \
		curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
		apt-get install -y nodejs; \
	fi

# No UI on arm32 on Ubuntu 24.04
ARG TARGETARCH
RUN if [ "$TARGETARCH" != "arm" ]; then \
		# X11 Server \
		apt-get install -y xvfb && \
		# Desktop Bus \
		apt-get install -y dbus-x11 && \
		mkdir -p /run/dbus; \
	fi

# VS Code dependencies
RUN apt-get install -y libasound2t64 && \
	apt-get install -y libgtk-3-0t64 && \
	apt-get install -y libcurl4t64 && \
	apt-get install -y \
	libgbm1 \
	libnss3 \
	xdg-utils
