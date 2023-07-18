ARG REPO=alpine
ARG TAG=3.16
FROM arm64v8/${REPO}:${TAG}

RUN apk add nodejs npm g++ python3 make git bash curl perl pkgconfig libsecret-dev krb5-dev
RUN npm install -g yarn

RUN mkdir -p /root/vscode
WORKDIR /root/vscode
