# syntax=docker/dockerfile:1
ARG ALPINE_LINUX_VERSION=3.13.1
ARG ELIXIR_VERSION=1.8.2
ARG OTP_VERSION=22.3.4

FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-alpine-${ALPINE_LINUX_VERSION} AS dev
HEALTHCHECK CMD wget --no-check-certificate https://localhost:4000/link -O /dev/null || exit 1
RUN mix do local.hex --force, local.rebar --force
RUN apk add --no-cache\
    # required by hex\
    git\
    # required by hex:phoenix_live_reload\
    inotify-tools
COPY files/dev-perms.pem /etc/perms.pem
WORKDIR /code
