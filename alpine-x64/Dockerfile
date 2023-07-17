ARG REPO=alpine
ARG TAG=3.16
FROM ${REPO}:${TAG}

RUN apk add g++ python3 make git bash curl perl pkgconfig libsecret-dev

RUN mkdir -p /root/vscode
WORKDIR /root/vscode