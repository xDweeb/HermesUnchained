.DEFAULT_GOAL := help

.PHONY: help setup start stop status logs clean service-install service-start service-stop service-logs

CLI := ./bin/hermes-unchained

help:
	@printf '%s\n' \
	  'HermesUnchained commands:' \
	  '  make setup   Create .env and verify dependencies' \
	  '  make start   Start OmniRoute and launch Hermes' \
	  '  make stop    Stop Hermes and OmniRoute' \
	  '  make status  Show runtime status' \
	  '  make logs    Stream OmniRoute logs' \
	  '  make clean   Remove runtime container (preserves data)' \
	  '  make service-install  Install and enable the user systemd service' \
	  '  make service-start    Start the background service' \
	  '  make service-stop     Stop the background service' \
	  '  make service-logs     Follow background service logs'

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

service-install:
	@$(CLI) install-service

service-start:
	@systemctl --user start hermes-unchained.service

service-stop:
	@systemctl --user stop hermes-unchained.service

service-logs:
	@journalctl --user --unit hermes-unchained.service --follow
