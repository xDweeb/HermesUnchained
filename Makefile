.DEFAULT_GOAL := help

.PHONY: help setup setup-ide setup-skills start chat claude aider stop status logs clean rotate-logs service-install service-start service-stop service-logs

CLI := ./bin/hermes-unchained

help:
	@echo "============================================================"
	@echo "  HermesUnchained - Customized by xDweeb"
	@echo "============================================================"
	@echo ""
	@echo "AI commands:"
	@echo "  make chat         : Launch Hermes interactive chat"
	@echo "  make claude       : Launch Claude Code CLI"
	@echo "  make aider        : Launch Aider AI coding assistant (Supports MODE=web, backend, data, ctf, robotics)"
	@echo "  make setup-ide    : Generate VS Code integration guide"
	@echo "  make setup-skills : Initialize advanced AI skills and auto-linting"
	@echo "  make help         : Show this help message"
	@echo ""
	@echo "Runtime and service commands:"
	@echo "  make setup        : Create .env and verify dependencies"
	@echo "  make start PROMPT=\"...\" : Run one prompt and exit"
	@echo "  make status       : Show runtime status"
	@echo "  make logs         : Stream OmniRoute logs"
	@echo "  make stop         : Stop Hermes and OmniRoute"
	@echo "  make clean        : Remove runtime container (preserves data)"
	@echo "  make rotate-logs  : Compress and expire Hermes log files"
	@echo "  make service-install : Install and enable the user systemd service"
	@echo "  make service-start   : Start the background service"
	@echo "  make service-stop    : Stop the background service"
	@echo "  make service-logs    : Follow background service logs"
	@echo ""

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
