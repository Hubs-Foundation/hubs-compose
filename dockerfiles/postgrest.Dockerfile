# syntax=docker/dockerfile:1
ARG POSTGREST_VERSION=v9.0.1

FROM postgrest/postgrest:${POSTGREST_VERSION}
# User 1000 comes from
# https://github.com/PostgREST/postgrest/blob/b56648147719/nix/tools/docker/default.nix#L24
COPY --chown=1000:1000 files/dev-reticulum-jwk.json /reticulum-jwk.json
COPY --chown=1000:1000 files/dev-reticulum.conf /reticulum.conf
ENTRYPOINT ["postgrest", "reticulum.conf"]
