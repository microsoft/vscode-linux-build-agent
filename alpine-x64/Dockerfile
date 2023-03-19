ARG REPO=node
ARG TAG=16.19.1-alpine
FROM ${REPO}:${TAG}

RUN apk add g++ python3 make git bash curl perl pkgconfig libsecret-dev

RUN mkdir -p /root/vscode
WORKDIR /root/vscode