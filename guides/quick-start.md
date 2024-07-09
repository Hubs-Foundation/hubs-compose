# Hubs Cloud Data Migration to Community Edition

Hey everyone, this is [@mikemorran](https://github.com/mikemorran)!

I am writing this guide covering how to get started with local Hubs development using Hubs Compose. The commands shown in this guide were executed on my 2022 Macbook Pro; You may need to adjust the commands and dependencies for your operating system.

The community and I covered this process in a Community Edition Setup Session on April 17, 2024. See the recording here: https://youtu.be/BULDwyiNLzU

This process will cover the following steps...

1. [Prerequisites](#prerequisites)
2. [Installation with Custom Repos](#installation-with-custom-repos)
3. [Running Hubs Compose](#running-hubs-compose)
4. [Getting Into The Admin Panel](#getting-into-the-admin-panel)
5. [Testing Our First Hubs Room](#testing-our-first-hubs-room)
6. [Other Hubs Compose Scripts](#other-hubs-compose-scripts)
7. [Developing With Hubs Compose](#developing-with-hubs-compose)

### Prerequisites

- [Docker Compose](https://docs.docker.com/compose/install), I used `Docker Compose version 2.26.1`
- [Mutagen](https://mutagen.io/documentation/introduction/installation), I used `Mutagen version 0.17.5`
- [Mutagen Compose](https://github.com/mutagen-io/mutagen-compose#system-requirements)
- Add `127.0.0.1 hubs.local` and `127.0.0.1 hubs-proxy.local` to your local hosts. I did this by running `nano /etc/hosts`
- Clone this repo onto your device with `git clone https://github.com/Hubs-Foundation/hubs-compose`

### Installation with Custom Repos

Before we begin the installation process for Hubs Compose, I want to switch out the Hubs repos in `bin/init` lines 10-13 with my own forks of the Hubs repos. When I am done and run `bin/init`, Hubs Compose will copy a local clone of all four repos - Hubs, Spoke, Dialog, and Reticulum - and build them into Docker images and volumes. You do not need to install Hubs Compose each time you wish to develop locally, only in this setup phase which can take ~30 minutes.

### Running Hubs Compose

Once our Docker images and volumes have been built, we can see a new `/services/` directory has been added to our local copy of the Hubs Compose repo. Next, I will run `bin/up` to spin up Docker containers for my local development. I like to use [Docker Desktop](https://www.docker.com/products/docker-desktop/) to monitor these containers and view container logs. If successful, we should see containers created for all of the following...

- db
- dialog
- hubs-admin
- hubs-client
- hubs-storybook
- mutagen
- postgrest
- reticulum
- spoke

### Getting Into the Admin Panel

_Quick Tip: You can use a command like this `/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --ignore-certificate-errors` to open your browser without requiring certificate authentication. Otherwise, you will need to self-sign all certificates for Hubs Compose._

The first thing we should do when we have our local development running is attempt to connect to the admin panel. Since Hubs Compose is not a fully featured Hubs instance, we will need a work-around for the magic email links that would normally require an SMTP service to allow users to log in. To log in to the admin panel, we will follow these steps...

1. Open `https://hubs.local:4000` and attempt to sign in with your email.
2. Open your reticulum container's logs and look for a log with the magic email link. Copy and open this link in the browser to complete verification. This will create the first entry in our accounts table.

```log
%Bamboo.Email{from: {nil, "info@hubs-mail.com"}, to: [nil: "mmorran@mozilla.com"], cc: [], bcc: [], subject: "Your  Sign-In Link", html_body: nil, text_body: "To sign-in to , please visit the link below. If you did not make this request, please ignore this e-mail.\n\n https://hubs.local:4000/?auth_origin=hubs&auth_payload=GPk2GOEbz9AcHROddvD%2F20%2B11FcKH%2FbKTj62gPCyUgjpeogFp94zpQoBh9nrBiY%2F16KYiGka0dseW9mDlN7n&auth_token=ca3ff98f63c4b7709d0b1c01a217f414&auth_topic=auth%3Add0ec69c-bfa2-4994-b183-aca1377b2f11", headers: %{}, attachments: [], assigns: %{}, private: %{}}
```

3. Next, we need to promote this account to give it access to the admin panel. Execute into our reticulum container and run the following command to open an interactive session: `mix iex -S mix`
4. In the interactive session, run the following command to promote the first entry in our accounts table: `Ret.Account |> Ret.Repo.all() |> Enum.at(0) |> Ecto.Changeset.change(is_admin: true) |> Ret.Repo.update!()`
5. Attempt to log in with your email once again and you should now have access to the admin panel at `https://hubs.local:4000/admin`. You may need to re-accept your magic-link email in your reticulum container's logs.

### Testing Our First Hubs Room

In local development, `https://hubs.local:4000` is used for the Admin Panel and Spoke, while `https://hubs.local:8080` is used to connect to Hubs rooms. You can connect to `https://hubs.local:8080` in your browser and select "Create A Room" to begin testing the world. If successful, you should also be able to open multiple tabs to test real-time audio connection locally.

### Other Hubs Compose Scripts

- `bin/down` | When I am done developing, I run this command to remove my Docker containers.
- `bin/observe` | This command helps you view container information and logs.
- `bin/services-update` | This command will re-install each of the Hubs codebases without erasing your local development data.
- `bin/reset` | This command fully resets your local development instances and data, removing your volumes in the process.

### Developing with Hubs Compose

Hubs Compose will be the best way to run Hubs locally following the shutdown of Mozilla-run servers on May 31, 2024. When running Hubs Compose, you can make and save edits to the local copies of Hubs, Spoke, Dialog, and Reticulum in `/services/`, which will recompile your code for testing in real time. Hubs Team developers typically only use the 4 local copies of Hubs codebases as their main development repos and push features directly from them.
