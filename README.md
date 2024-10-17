# Hubs Compose

Hubs Compose is a Docker Compose setup that can be used to orchestrate all the
services used by Hubs for local development. It runs on Windows, MacOS or Linux.

> [!IMPORTANT]
> This is not a production-ready setup.  It does not account for
security or scalability.  Additionally the permissions files were generated for
development purposes only.

## Prerequisites
* [Docker](https://docs.docker.com/engine/install/binaries/) (Linux note: it is expected that you add your user to the `docker` group and that you don't run the commands with sudo)
* [Docker Compose](https://docs.docker.com/compose/install)
* [Mutagen](https://mutagen.io/documentation/introduction/installation) (Linux note: installing the binaries manually in `/usr/local/bin` is probably the best route)  The scripts start the Mutagen daemon, so it is *not* necessary to configure your system to automatically start mutagen on boot.
* [Mutagen Compose](https://github.com/mutagen-io/mutagen-compose#system-requirements) (Linux note: installing the binaries manually in `/usr/local/bin` is probably the best route)

> [!NOTE]
> Mac Homebrew Formulae for those wanting to avoid installing the proprietary Docker Desktop on Macs.
> https://formulae.brew.sh/formula/docker
> https://formulae.brew.sh/formula/docker-compose

> [!IMPORTANT]
> Ensure that the version of Mutagen Compose you're installing matches the version of Mutagen that you installed. (If you install the latest versions at the same time, they will "match", but for this reason it may be better to install the binaries explicitly and make sure that the versions for each are exactly the same).

* The `tmux` and `watch` programs (Optional dependencies needed by the `bin/observe` script)

* Add these entries to your hosts file:

        127.0.0.1   hubs.local
        127.0.0.1   hubs-proxy.local

  - On Windows, your plain-text `hosts` file is probably located at `C:\Windows\System32\drivers\etc\hosts`.

### Windows Specific Prerequisites
#### Summary
* (Optional) [Install WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
* Ensure Git checks out Unix line endings
* Use Git Bash to run scripts

#### (Optional) Install WSL2
**Docker Desktop runs more quickly** when it can use its WSL2-based engine. Docker Desktop can only use its WSL2 engine if WSL2 is installed.

There are also other benefits to installing WSL2, including being able to run scripts and programs that your Unix developer friends share with you.

To install WSL2, follow Microsoft's documentation here: [Install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

##### ⚠️ Potential Conflict
If you plan to run Docker Desktop on Windows, _and_ you want to take advantage of Docker Desktop's faster WSL2 engine, _and_ you already have WSL2 installed, you need to first [uninstall any previous versions of Docker Engine and CLI installed directly through WSL2](https://docs.docker.com/desktop/wsl/#turn-on-docker-desktop-wsl-2).

You can [read more about Docker Desktop + WSL2 on Docker's website.](https://docs.docker.com/desktop/wsl/#turn-on-docker-desktop-wsl-2)

#### Use Unix Line Endings
Some scripts used to run `hubs-compose` rely on those scripts containing Unix line endings. If you're running `hubs-compose` on Windows, you may need to change your Git line endings setting to ensure your local files include Unix-style line endings.

To change this setting, open a Git Bash shell, then **run `git config --global core.autocrlf false`** to ensure that the intended Unix-style line endings are preserved upon Git checkout.

If you've already cloned this `hubs-compose` repository locally, you may have to delete your local copy of the repository and re-clone it after changing your line endings setting.

#### Use Git Bash
Some scripts used to run `hubs-compose` are meant to run in a Unix-like `bash` shell. The "Git Bash" shell included with Git - also known as MINGW64 - will work to run these scripts; the Windows Terminal will not work to run these scripts.

## Initial Setup
1. Initialize the services with `bin/init`
2. Start the containers with `bin/up`
3. Self-Sign the certificates (see the [Self-Signed Certificates section](#self-signed-certificates) below)
4. Sign into Hubs (see the [Signing into Hubs section](#signing-into-hubs) below)
5. Create an admin user (see the [Admin panel access section](#admin-panel-access) below)


## Usage
* You can start Hubs Compose with `bin/up`.
* Once started, you can access the Hubs admin panel, Spoke, or Hubs rooms via:
  - [Reticulum](https://hubs.local:4000)
* Any changes to the code of the various repositories in the services folder that you make while the containers are running will be automatically picked up and deployed (this happens when you start it as well).
* When you're finished, stop Hubs Compose with `bin/down && mutagen daemon stop`.


### Orchestration

* Start the containers with `bin/up`
  - `bin/up` starts the Mutagen daemon automatically. The Mutagen daemon will stay running until you stop it manually with `mutagen daemon stop`.
* Stop the containers with `bin/down`
* Observe running containers with `bin/observe`[^1]
* Reset all the containers/services to a fresh state with `bin/reset`
  - This deletes the containers, volumes, and images (along with any of the dependencies stored on them) and recreates them.  As a result, you will likely need to redo most of the steps in the [Initial Setup section](#initial-setup) above.
  - A hard reset can be achieved by running `bin/down` and then `docker system prune -af && docker volume prune -af` before running `bin/reset` (this will clear everything, including the docker build cache, so you can make sure nothing is getting reused from the cache)
    - Note: a hard reset will affect your whole Docker ecosystem and not just the Hubs services.  If you have any containers/images/volumes/etc. that aren't running, but you still want to keep DO NOT PERFORM A HARD RESET.
* Update all non-customized service source code with `bin/services-update`
* Initialize services and/or update service dependencies with `bin/init`
  - This should be run whenever a service's dependencies change, e.g. when a new node module or Hubs Client add-on has been added.
  - Note: this will not affect the GitHub repositories cloned into the `services` folder, it will just ignore them.
* You can restart Hubs Compose with this chained command: `bin/down && mutagen daemon stop && bin/up`

[^1]: Requires `tmux` and `watch` program files in the user’s path

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

> [!NOTE]
> Seeing a page with the text "Cannot get /" when visiting Dialog (hubs.local:4443) after self-signing the certificate is normal.
> Seeing a page with the text "Cannot get /" when visiting Hubs Admin (hubs.local:8989) after self-signing the certificate is normal.

### Signing into Hubs

1. Go to [Reticulum](https://hubs.local:4000) and click the sign in/up button.
2. Enter an email address (it doesn't have to be real) that you'll remember (or write it down somewhere after).
    - Note: this will be the email address used for your admin account.
3. View the logs for the Reticulum container:  `docker compose logs reticulum ` (add `-f` if you want a live update)
4. Copy the magic verification link and open it in a new tab on your browser.
    - Note: it must be the same browser as your other Hubs Compose tabs are in.

Example Reticulum log entry for the magic link email:

`%Bamboo.Email{from: {nil, "info@hubs-mail.com"}, to: [nil: "<your@email.address>"], cc: [], bcc: [], subject: "Your  Sign-In Link", html_body: nil, text_body: "To sign-in to , please visit the link below. If you did not make this request, please ignore this e-mail.\n\n https://hubs.local:4000/?auth_origin=hubs&auth_payload=GPk2GOEbz9AcHROddvD%2F20%2B11FcKH%2FbKTj62gPCyUgjpeogFp94zpQoBh9nrBiY%2F16KYiGka0dseW9mDlN7n&auth_token=ca3ff98f63c4b7709d0b1c01a217f414&auth_topic=auth%3Add0ec69c-bfa2-4994-b183-aca1377b2f11", headers: %{}, attachments: [], assigns: %{}, private: %{}}`

### Admin panel access

To connect to the admin panel you will need to shell into the reticulum container and manually [promote an account to admin](https://github.com/Hubs-Foundation/reticulum#6-creating-an-admin-user).

You can shell into the reticulum container and start an iex console by running `services/reticulum/bin/iex -S mix`

> [!NOTE]
> You must have signed in/created an account previously in order to promote it to admin.  By default, the first account you sign in with/create will end up being the one promoted to be the admin account.

After you have promoted an account to admin, clear your local storage (see the [Clearing Local Storage section](#clearing-local-storage) below) and then sign in again.

### Useful Docker commands

* `docker compose ps` - Lists running containers and some basic info on them (includes the service name).
  - Add `-a` to list all the containers, including stopped ones.
* `docker compose logs <servicename>` - Shows the logs for the container.
  - Add `-f` if you want a live update.
* ` docker compose exec -ti <servicename> sh` - Opens an interactive shell inside the container for `<servicename>`
  - Run `exit` to get out of the shell and back to your normal terminal.
* `docker image ls` - Lists images and some basic info on them.
* `docker image rmi <ID>` - Removes the image with `<ID>`.
* `docker volume ls` - Lists volumes and some basic info on them.
* `docker volume rm <ID>` - Removes the volume with `<ID>`.
* `docker container ls` - Lists containers and some basic info on them (includes the container ID).
* `docker buildx prune -af` - Removes the docker build cache.
* `docker system df` - Displays stats about your docker ecosystem.
* `docker system prune -af && docker volume prune -af` - Removes all non-running/unused containers/volumes/images/etc., and removes the docker build cache.


> [!NOTE]
> You may see that some of the Hubs scripts use the -f flag in docker compose commands.  According to https://docs.docker.com/reference/cli/docker/compose/
> "The -f flag is optional. If you don’t provide this flag on the command line, Compose traverses the working directory and its parent directories looking for a compose.yaml or docker-compose.yaml file."

### Reticulum Convenience Scripts

Common commands for Reticulum can be easily executed inside its running container
from your shell using the scripts inside the Reticulum service’s `bin/` directory.
For example, calling `bin/mix deps.get` from `./services/reticulum/` will download
the dependencies for Reticulum.

## Troubleshooting

Experiencing issues with `hubs-compose`? Follow these steps to diagnose and resolve
common problems:

* Ensure your operating system, internet browser, and Docker installation are
up-to-date.
* Update your local copy of the `hubs-compose` repository and all related service
source codes to the latest versions.
* If `bin/init` presents problems, remove any existing `hubs-compose` containers,
images, and volumes, then retry the command.
* For SSL certificate issues, clearing your local browser cache may resolve the
problem (see the [Hard Refreshing A Page section](#hard-refreshing-a-page) below).
* Make sure you are using `hubs.local` and not `localhost`, Hubs Compose requires that you use `hubs.local`.
* If you are using the Brave browser, or privacy plugins, and you run into issues, make sure to turn Brave's shields off/disable the privacy plugins for both `hubs.local` and `hubs-proxy.local`.
* If you see unexpected errors printed to the page, try refreshing (it may take a couple times).
  - Possible causes for this include: changing the code (this is normal, you'll likely need to refresh twice).
* If you see errors printed to the page (not the console), and refreshing the page hasn't worked, try clearing your local storage for the page (see the [Clearing Local Storage section](#clearing-local-storage) below).
* If you see errors printed to the page (not the console) talking about not being able to read the credentials after clearing your local storage, try refreshing the page.
* If you see errors printed to the page after waking your computer up from sleep, try restarting Hubs Compose.
* If you see errors printed to the page (not the console) complaining that dependencies like `bitecs` and `three` can't be found, and clearing the local storage/refreshing the page/restarting Hubs Compose hasn't worked, try running `bin/reset`.
  - Note: if you know what service is likely causing the problem, you can try to re-download all the dependencies for a single service by finding the mutagen compose command for the service in `bin/init` and running that on its own in a terminal (you'll probably have to replace `conditional-npm-ci` with `npm ci`).
* If you no longer get the reticulum email link when trying to log in, restart Hubs Compose.
* Reticulum needs to be restarted every 24 hours because JWT expires, restarting Hubs Compose fixes it.  If you see errors relating to JWT, this is why.
* If you are seeing timeouts when downloading dependencies (it's probably because of this bug: https://github.com/npm/cli/issues/3078), try replacing the `conditional-npm-ci` references in `bin/init` with the following, and then running `bin/init` or `bin/reset` again (note: you may want to restore the original `conditional-npm-ci` command once you are past this error to prevent an infinite loop if a different error comes up on a future run):
`sh -c 'checksum='package-lock.sha512'; if ! sha512sum --check --status $checksum 2>/dev/null; then npm config set fetch-timeout 1800000; npm config set fetch-retries 100; npm ci; exitcode="$?"; while [ "$exitcode" -eq 1 ]; do npm ci; exitcode="$?"; done; sha512sum package-lock.json > $checksum; fi'`
* if you are stuck on loading the room, try restarting Hubs Compose.
* If the above steps do not resolve the issue, try restarting your browser.
* If the above steps do not resolve the issue, try restarting docker.
* If the above steps do not resolve the issue, try restarting your machine.

If problems persist after these steps, consider reaching out for community support
or filing an issue in the repository.

### Clearing Local Storage

You can clear your local storage by opening the dev tools in your browser (Ctrl+Shift+I, or Cmd+Shift+I on Mac), navigating to the Application tab (Chrome) or the Storage tab (Firefox), expanding the "Local storage" tree item, and then deleting the key/value pairs stored there.

### Hard Refreshing A Page

Rather than just refreshing your page, it's probably beneficial to remove the cache as well by performing a hard refresh, just to make sure there isn't any stale data causing problems.
To hard refresh a page in Chrome/Firefox you can use the Ctrl+Shift+R hotkey (Cmd+Shift+R on Mac).  This will also clear the cache for that page.  For other browsers, see this page: https://filecamp.com/support/problem-solving/hard-refresh/


## Development

### Architectural Decision Records

[Records of architectural decisions](https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
are stored in the `decisions/` directory.  If you make a decision that affects
“the structure, non-functional characteristics, dependencies, interfaces, or
construction techniques” of the project, please document it.  If you
[install ADR Tools](https://github.com/npryce/adr-tools#quick-start), `adr new`
will generate the template for you.
