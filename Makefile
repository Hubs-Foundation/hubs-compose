basedir=$(PWD)
servicesdir=$(basedir)/services
composefile=$(basedir)/docker-compose.yml
prefix=\n\033[1;37m
suffix=\033[0m\n

.PHONY: init
init: check clone reticulum dialog hubs-admin hubs-client spoke
	@printf "$(prefix)Done$(suffix)" && \
		mutagen-compose down

.PHONY: check
check:
	hash docker-compose || exit 1
	hash mutagen-compose || exit 1

.PHONY: clone
clone:
	@printf "$(prefix)Cloning source repositories$(suffix)"
	-git clone https://github.com/mozilla/reticulum.git $(servicesdir)/reticulum
	-git clone https://github.com/mozilla/dialog.git $(servicesdir)/dialog
	-git clone https://github.com/mozilla/hubs.git $(servicesdir)/hubs
	-git clone https://github.com/mozilla/Spoke.git $(servicesdir)/spoke

.PHONY: reticulum
reticulum: check
	@printf "$(prefix)Initializing Reticulum$(suffix)" && \
		docker-compose -f $(composefile) build reticulum && \
		mutagen-compose -f $(composefile) run --rm reticulum \
		sh -c 'trapped-mix do deps.get, deps.compile, ecto.create'

.PHONY: dialog
dialog: check
	@printf "$(prefix)Initializing Dialog$(suffix)" && \
		docker-compose -f $(composefile) build dialog && \
		mutagen-compose -f $(composefile) run --rm dialog conditional-npm-ci

.PHONY: hubs-admin
hubs-admin: check
	@printf "$(prefix)Initializing Hubs Admin$(suffix)" && \
		docker-compose -f $(composefile) build hubs-admin && \
		mutagen-compose -f $(composefile) run --rm hubs-admin conditional-npm-ci

.PHONY: hubs-client
hubs-client: check
	@printf "$(prefix)Initializing Hubs Client$(suffix)" && \
		docker-compose -f $(composefile) build hubs-client && \
		mutagen-compose -f $(composefile) run --rm hubs-client conditional-npm-ci

.PHONY: spoke
spoke: check
	@printf "$(prefix)Initializing Spoke$(suffix)" && \
		mutagen-compose -f $(composefile) run --rm spoke yarn install

.PHONY: up
up: check
	mutagen-compose -f $(composefile) up --build --detach

.PHONY: down
down: check
	mutagen-compose -f $(composefile) down

.PHONY: reset
reset: clean init

.PHONY: clean
clean: check
	mutagen-compose -f $(composefile) down --volumes --rmi local && \
		rm -rf $(basedir)/services/reticulum/deps

