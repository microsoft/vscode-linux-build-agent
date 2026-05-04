ARG BASE_IMAGE=fedora:43
FROM ${BASE_IMAGE}

RUN dnf update -y

# Node.js 22
RUN curl -fsSL https://rpm.nodesource.com/setup_22.x | bash - && \
	dnf install -y nodejs-22.22.2

# Chromium
RUN dnf install -y chromium
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Desktop Bus
RUN dnf install -y dbus-x11 && \
	mkdir -p /run/dbus

# X11 Server
RUN dnf install -y xorg-x11-server-Xvfb

# VS Code dependencies
RUN dnf install -y xdg-utils
