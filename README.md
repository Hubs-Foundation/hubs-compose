# Hubs Compose

Hubs Compose is a Docker Compose setup than can be used to orchestrate all the
services used by Mozilla Hubs for local development.[^1]

[^1]: This is not a production-ready setup.  It does not account for
security or scalability.  Additionally the permissions files were generated for development purposes only.

## Usage

Once the containers are up and running and you have accepted the self-signed
certificates, you can visit https://hubs.local:4000 from your browser.

### Initial Setup

1. [Install Docker Compose](https://docs.docker.com/compose/install)
2. [Install Mutagen Compose](https://github.com/mutagen-io/mutagen-compose#system-requirements)
3. Add these entries to your hosts file:

        127.0.0.1   hubs.local
        127.0.0.1   hubs-proxy.local

4. Initialize the services with `bin/init`

### Orchestration

* Start containers with `bin/up`
* Stop containers `bin/down`
* Observe running containers with `bin/observe`[^2]
* Restore all services to a fresh state with `bin/reset`

[^2]: Requires `tmux` and `watch` program files in the user’s path

### Self-Signed Certificates

Service communication is encrypted with self-signed Transport Layer Security
(TLS) certificates.  You will need to accept the certificate at each of the
ports mapped in [`docker-compose.yml`](docker-compose.yml).  At the time of this
writing, that means visiting these links in your web browser and following the
prompts:

* [4443: Dialog](https://hubs.local:4443)
* [9090: Spoke](https://hubs.local:9090)
* [8989: Hubs Admin](https://hubs.local:8989)
* [8080: Hubs Client](https://hubs.local:8080)
* [4000: Reticulum](https://hubs.local:4000)

### Admin panel access

To connect to the admin panel you will need to manually promote an account to admin:
https://github.com/mozilla/reticulum#6-creating-an-admin-user

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
