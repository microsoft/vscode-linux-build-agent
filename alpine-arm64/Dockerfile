FROM arm64v8/alpine:3.16

RUN apk add g++ python make git bash curl perl pkgconfig libsecret-dev && uname -m

RUN mkdir -p /root/vscode
WORKDIR /root/vscode
