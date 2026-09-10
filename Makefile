.DEFAULT_GOAL := help

.PHONY: help setup setup-ide setup-skills start chat claude aider stop status logs clean rotate-logs service-install service-start service-stop service-logs

CLI := ./bin/hermes-unchained

help:
	@printf '%s\n' \
	  'HermesUnchained commands:' \
	  '  make setup   Create .env and verify dependencies' \
	  '  make setup-ide  Generate the VS Code AI integration guide' \
	  '  make setup-skills  Generate Aider config and expert skill files' \
	  '  make start PROMPT="..."  Run one prompt and exit' \
	  '  make chat    Start an interactive Hermes chat' \
	  '  make claude  Start Claude Code through the local OmniRoute bridge' \
	  '  make aider   Start aider through the local OmniRoute bridge' \
	  '  make stop    Stop Hermes and OmniRoute' \
	  '  make status  Show runtime status' \
	  '  make logs    Stream OmniRoute logs' \
	  '  make clean   Remove runtime container (preserves data)' \
	  '  make rotate-logs      Compress and expire Hermes log files' \
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
	@printf '%s\n' 'Setup complete. Review .env, then run make chat.'

setup-ide:
	@$(CLI) setup-ide

setup-skills:
	@$(CLI) setup-skills

start:
	@test -n "$$PROMPT" || { printf '%s\n' 'Usage: make start PROMPT="your task"'; exit 2; }
	@$(CLI) start "$$PROMPT"

chat:
	@$(CLI) chat

claude:
	@$(CLI) claude

aider:
	@MODE="$(MODE)" $(CLI) aider

stop:
	@$(CLI) stop

status:
	@$(CLI) status

logs:
	@$(CLI) logs

clean:
	@$(CLI) clean

rotate-logs:
	@$(CLI) rotate-logs

service-install:
	@$(CLI) install-service

service-start:
	@systemctl --user start hermes-unchained.service

service-stop:
	@systemctl --user stop hermes-unchained.service

service-logs:
	@journalctl --user --unit hermes-unchained.service --follow
