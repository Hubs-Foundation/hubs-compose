# syntax=docker/dockerfile:1
ARG NODE_VERSION=12.9

FROM --platform=linux/amd64 node:${NODE_VERSION} AS dev
HEALTHCHECK CMD curl -f http://localhost:7000/meta || exit 1
COPY files/dev-perms.pub.pem /etc/perms.pub.pem
COPY services/reticulum/priv/dev-ssl.cert /etc/ssl/fullchain.pem
COPY services/reticulum/priv/dev-ssl.key /etc/ssl/privkey.pem
