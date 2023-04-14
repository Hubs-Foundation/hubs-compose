# syntax=docker/dockerfile:1
ARG NODE_VERSION=16.16

FROM --platform=linux/amd64 node:${NODE_VERSION}
COPY files/conditional-npm-ci /usr/local/bin/conditional-npm-ci
