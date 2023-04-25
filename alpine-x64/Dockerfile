ARG REPO=node
ARG TAG=14.16.0-alpine
FROM ${REPO}:${TAG}

RUN apk add g++ python make git bash curl perl pkgconfig libsecret-dev

RUN mkdir -p /root/vscode
WORKDIR /root/vscode