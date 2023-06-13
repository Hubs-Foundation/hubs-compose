basedir=$(PWD)
servicesdir=$(basedir)/services
composefile=$(basedir)/docker-compose.yml
prefix=\n\033[1;37m
suffix=\033[0m\n

all: init

.PHONY: check
check:
	hash mutagen-compose || exit 1

.PHONY: clone
clone:
	@printf "$(prefix)Cloning source repositories$(suffix)"
	-git clone https://github.com/mozilla/reticulum.git $(servicesdir)/reticulum
	-git clone https://github.com/mozilla/dialog.git $(servicesdir)/dialog
	-git clone https://github.com/mozilla/hubs.git $(servicesdir)/hubs
	-git clone https://github.com/mozilla/Spoke.git $(servicesdir)/spoke

.PHONY: reticulum
reticulum:
	@printf "$(prefix)Initializing Reticulum$(suffix)" && \
		docker-compose -f $(composefile) build reticulum && \
		mutagen-compose -f $(composefile) run --rm reticulum \
		sh -c 'trapped-mix do deps.get, deps.compile, ecto.create'

.PHONY: dialog
dialog:
	@printf "$(prefix)Initializing Dialog$(suffix)" && \
		docker-compose -f $(composefile) build dialog && \
		mutagen-compose -f $(composefile) run --rm dialog conditional-npm-ci

.PHONY: hubs-admin
hubs-admin:
	@printf "$(prefix)Initializing Hubs Admin$(suffix)" && \
		docker-compose -f $(composefile) build hubs-admin && \
		mutagen-compose -f $(composefile) run --rm hubs-admin conditional-npm-ci

.PHONY: hubs-client
hubs-client:
	@printf "$(prefix)Initializing Hubs Client$(suffix)" && \
		docker-compose -f $(composefile) build hubs-client && \
		mutagen-compose -f $(composefile) run --rm hubs-client conditional-npm-ci

.PHONY: spoke
spoke:
	@printf "$(prefix)Initializing Spoke$(suffix)" && \
		mutagen-compose -f $(composefile) run --rm spoke yarn install

.PHONY: init
init: check clone reticulum dialog hubs-admin hubs-client spoke
	@printf "$(prefix)Done$(suffix)" && \
		mutagen-compose down

.PHONY: up
up:
	mutagen-compose -f $(composefile) up --build --detach

.PHONY: down
down:
	mutagen-compose -f $(composefile) down

.PHONY: reset
reset: clean-reticulum init

.PHONY: clean
clean:
	rm -rf $(servicesdir)

.PHONY: clean-reticulum
clean-reticulum:
	mutagen-compose -f $(composefile) down --volumes --rmi local && \
		rm -rf $(basedir)/services/reticulum/deps

