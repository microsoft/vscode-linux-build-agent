ARG BASE_IMAGE=debian:13
FROM ${BASE_IMAGE}

# Utilities
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y curl

# Node.js (arm32 uses official tarball since NodeSource dropped armhf support)
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "arm" ]; then \
		apt-get install -y libatomic1 && \
		curl -fsSL https://nodejs.org/dist/v22.22.2/node-v22.22.2-linux-armv7l.tar.gz | tar -xz -C /usr/local --strip-components=1; \
	else \
		curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
		apt-get install -y nodejs; \
	fi

# Chromium
RUN apt-get install -y --no-install-recommends chromium
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium

# Desktop Bus
RUN apt-get install -y dbus-x11 && \
    mkdir -p /run/dbus

# X11 Server
RUN apt-get install -y xvfb
