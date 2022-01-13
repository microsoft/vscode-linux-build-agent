FROM arm64v8/node:14.16.0-alpine

RUN apk add g++ python make git bash curl perl pkgconfig libsecret-dev && uname -m

RUN mkdir -p /root/vscode
WORKDIR /root/vscode
