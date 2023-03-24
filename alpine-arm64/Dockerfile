FROM arm64v8/node:16.19.1-alpine

RUN apk add g++ python3 make git bash curl perl pkgconfig libsecret-dev && uname -m

RUN mkdir -p /root/vscode
WORKDIR /root/vscode
