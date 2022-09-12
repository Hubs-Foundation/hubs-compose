# 2. Use Mutagen Compose

Date: 2022-09-12

## Status

Accepted

## Context

Docker is extremely slow on macOS out of the box.  The bottleneck is the file
synchronization that utilizes bind mounts.  We want the benefits of a
containerized development environment on macOS with tolerable performance.  The
solution must not adversely affect performance to any noticeable degree on
another operating system.

## Decision

We will use
[Mutagen Compose](https://mutagen.io/documentation/orchestration/compose) to
“provide a high-performance alternative to the virtual filesystems used in
Docker Desktop bind mounts.”

## Consequences

We receive the automation and isolation benefits of a containerized development
environment on macOS with performance approaching that of a “bare metal”
installation.  Mutagen Compose does not noticeably affect file synchronization
on other operating systems.

While other alternatives to bind mounts exist, such as Docker-Sync and NFS
volumes, Mutagen performs better
[in](https://medium.com/@marickvantuil/speed-up-docker-for-mac-with-mutagen-14c2a2c9cba7)
[benchmarks](https://medium.com/swlh/trying-to-improve-docker-performance-on-macos-using-mutagen-699716e44825).

Since Mutagen Compose relies upon volumes, any files from the synced directory
in the image will be overwritten.  For this reason the dockerfiles do not
bother to fetch dependencies.
