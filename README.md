# Hubs Compose

Hubs Compose is a Docker Compose setup than can be used to orchestrate all the
services used by Mozilla Hubs for local development.[^1]

[^1]: This is not a production-ready setup.  It does not account for
security or scalability.  Additionally the permissions files were generated for
development purposes only.

## Windows Prerequisites
### Summary
- [Install WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
- Ensure Git checks out Unix line endings
- Use Git Bash to run scripts

### Install WSL2
Docker Desktop runs more quickly when it can use a WSL2-based engine. There are also other benefits to installing WSL2, including being able to run scripts and programs that your Unix friends share with you.

To install WSL2, follow Microsoft's documentation here: [Install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

### Use Unix Line Endings
Some scripts used to run `hubs-compose` rely on those scripts containing Unix line endings. If you're running `hubs-compose` on Windows, you may need to change your Git line endings setting to ensure your local files include Unix-style line endings.

To change this setting, open a Git Bash shell, then **run `git config --global core.autocrlf false`** to ensure that the intended Unix-style line endings are preserved upon Git checkout.

If you've already cloned this `hubs-compose` repository locally, you may have to delete your local copy of the repository and re-clone it after changing your line endings setting.

### Use Git Bash
Some scripts used to run `hubs-compose` are meant to run in a Unix-like `bash` shell. The "Git Bash" shell included with Git - also known as MINGW64 - will work to run these scripts; the Windows Terminal will not work to run these scripts.

## Usage

Once the containers are up and running and you have accepted the self-signed
certificates, you can visit https://hubs.local:4000 from your browser.

### Initial Setup

1. [Install Docker Compose](https://docs.docker.com/compose/install)
2. [Install Mutagen Compose](https://github.com/mutagen-io/mutagen-compose#system-requirements)
3. [Install Mutagen](https://mutagen.io/documentation/introduction/installation)
4. Add these entries to your hosts file:

        127.0.0.1   hubs.local
        127.0.0.1   hubs-proxy.local

  - On Windows, your plain-text `hosts` file is probably located at `C:\Windows\System32\drivers\etc\hosts`.
5. Initialize the services with `bin/init`

### Orchestration

First, ensure the Mutagen daemon is running with `mutagen daemon start`.

* Start containers with `bin/up`
* Stop containers `bin/down`
* Observe running containers with `bin/observe`[^2]
* Restore all services to a fresh state with `bin/reset`
* Update all service source code with `bin/services-update`
* Update service dependencies with `bin/init`

[^2]: Requires `tmux` and `watch` program files in the user’s path

### Self-Signed Certificates

Service communication is encrypted with self-signed Transport Layer Security
(TLS) certificates.  You will need to accept the proxy certificate and the
certificate at each of the Hubs ports mapped in
[`docker-compose.yml`](docker-compose.yml).  At the time of this writing, that
means visiting these links in your web browser and following the prompts:

* [Proxy](https://hubs-proxy.local:4000)
* [Dialog](https://hubs.local:4443)
* [Spoke](https://hubs.local:9090)
* [Hubs Admin](https://hubs.local:8989)
* [Hubs Client](https://hubs.local:8080)
* [Reticulum](https://hubs.local:4000)

### Admin panel access

To connect to the admin panel you will need to manually
[promote an account to admin](https://github.com/mozilla/reticulum#6-creating-an-admin-user).

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
