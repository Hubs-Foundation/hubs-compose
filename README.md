# Hubs Compose

Hubs Compose is a Docker Compose setup than can be used to orchestrate all the
services used by Mozilla Hubs for local development.[^1]

[^1]: This is not a production-ready setup.  It does not account for
security or scalability.  Additionally the permissions files were generated for development purposes only.

## Usage

### Initial Setup

* [Install Docker Compose](https://docs.docker.com/compose/install)
* [Install Mutagen Compose](https://github.com/mutagen-io/mutagen-compose#installation)
* Clone service repositories with `bin/init`

### Orchestration

* Start containers with `bin/up`
* Stop containers `bin/down`
* Wipe the slate clean with `bin/clean`
* Observe running containers with `bin/observe`[^2]

[^2]: Requires `tmux` and `watch` program files in the user’s path

### Command Execution

Common commands can be easily executed inside a running container from your
shell using the scripts inside the given service’s `bin/` directory.  For
example, calling `bin/mix deps.get` from `./services/reticulum/` will download
the dependencies for Reticulum.

## Development

### Architectural Decision Records

[Records of architectural decisions](https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
are stored in the `decisions/` directory.  If you make a decision that affects
“the structure, non-functional characteristics, dependencies, interfaces, or
construction techniques” of the project, please document it.  If you
[install ADR Tools](https://github.com/npryce/adr-tools#quick-start), `adr new`
will generate the template for you.
