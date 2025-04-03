ARG REPO=mcr.microsoft.com/devcontainers/base
ARG TAG=alpine-3.18
FROM ${REPO}:${TAG}

RUN apk add nodejs npm g++ python3 make git bash curl perl pkgconfig libsecret-dev krb5-dev

RUN mkdir -p /root/vscode
WORKDIR /root/vscode
