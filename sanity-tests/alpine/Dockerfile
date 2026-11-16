ARG BASE_IMAGE=vscodehub.azurecr.io/cache/docker/library/alpine:3.22.8
FROM ${BASE_IMAGE}

RUN apk upgrade --no-cache

# Node.js 22
RUN apk add --no-cache nodejs curl

# Chromium
RUN apk add --no-cache chromium
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser
