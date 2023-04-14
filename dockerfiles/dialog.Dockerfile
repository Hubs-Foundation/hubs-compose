# syntax=docker/dockerfile:1
ARG NODE_VERSION=18

FROM node:${NODE_VERSION}
HEALTHCHECK CMD curl -f http://localhost:7000/meta || exit 1
RUN apt-get update && apt-get install -y \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*
COPY files/conditional-npm-ci /usr/local/bin/conditional-npm-ci
COPY files/dev-perms.pub.pem /etc/perms.pub.pem
COPY services/reticulum/priv/dev-ssl.cert /etc/ssl/fullchain.pem
COPY services/reticulum/priv/dev-ssl.key /etc/ssl/privkey.pem
CMD ["npm", "start"]
