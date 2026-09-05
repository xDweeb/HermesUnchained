.DEFAULT_GOAL := help

.PHONY: help setup start stop status logs clean

CLI := ./bin/hermes-unchained

help:
	@printf '%s\n' \
	  'HermesUnchained commands:' \
	  '  make setup   Create .env and verify dependencies' \
	  '  make start   Start OmniRoute and launch Hermes' \
	  '  make stop    Stop Hermes and OmniRoute' \
	  '  make status  Show runtime status' \
	  '  make logs    Stream OmniRoute logs' \
	  '  make clean   Remove runtime container (preserves data)'

setup:
	@test -f .env || cp .env.example .env
	@command -v docker >/dev/null
	@command -v curl >/dev/null
	@command -v hermes-agent >/dev/null
	@$(CLI) --version
	@printf '%s\n' 'Setup complete. Review .env, then run make start.'

start:
	@$(CLI) start

stop:
	@$(CLI) stop

status:
	@$(CLI) status

logs:
	@$(CLI) logs

clean:
	@$(CLI) clean
