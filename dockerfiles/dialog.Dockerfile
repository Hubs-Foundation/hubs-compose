# syntax=docker/dockerfile:1
ARG NODE_VERSION=18

FROM node:${NODE_VERSION} AS dev
HEALTHCHECK CMD curl -f http://localhost:7000/meta || exit 1
RUN apt-get update && apt-get install -y \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*
COPY files/dev-perms.pub.pem /etc/perms.pub.pem
COPY services/reticulum/priv/dev-ssl.cert /etc/ssl/fullchain.pem
COPY services/reticulum/priv/dev-ssl.key /etc/ssl/privkey.pem
