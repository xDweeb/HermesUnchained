# HermesUnchained

[![CI](https://github.com/xDweeb/HermesUnchained/actions/workflows/ci.yml/badge.svg)](https://github.com/xDweeb/HermesUnchained/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/xDweeb/HermesUnchained)](LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/diegosouzapw/omniroute?logo=docker)](https://hub.docker.com/r/diegosouzapw/omniroute)
[![Architecture](https://img.shields.io/badge/Architecture-local--first-7C3AED)](#architecture)
[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)](scripts/ops/hermes-unchained)

HermesUnchained is an isolated, local-first bridge between
[Hermes Agent](https://github.com/NousResearch/hermes-agent) and
[OmniRoute](https://github.com/diegosouzapw/OmniRoute). It provides one command for lifecycle
management, health checks, logs, upgrades, and an OpenAI-compatible local gateway—without
changing the user's normal Hermes configuration.

## Architecture

```text
┌──────────────┐     OpenAI-compatible API      ┌───────────────────┐
│ Hermes Agent │ ──────────────────────────────> │ OmniRoute Gateway │
│ isolated HOME│     localhost:<port>/v1         │ Docker, local-only│
└──────────────┘                                 └─────────┬─────────┘
                                                          │ smart routing
                                                          ▼
                                              ┌────────────────────────┐
                                              │ 350+ Free LLM Providers│
                                              └────────────────────────┘
```

OmniRoute binds to `127.0.0.1` and persists its state in `data/`. Hermes runs with a
repository-local home directory, so `~/.hermes` remains independent.

## Quick start

### Requirements

- Linux or macOS with Bash 4+
- Docker Engine with an accessible daemon
- `curl`
- `hermes-agent` on `PATH`

### Install and run

```bash
git clone https://github.com/xDweeb/HermesUnchained.git
cd HermesUnchained
make setup
make start
```

`make setup` creates an ignored `.env` from `.env.example`. On start, the manager launches
the dedicated OmniRoute container, retries its health endpoint for up to 60 seconds, and only
then starts Hermes Agent.

You can also use the CLI directly:

```bash
./bin/hermes-unchained start
```

Pass additional options to Hermes after `start`:

```bash
./bin/hermes-unchained start --max_turns=20
```

## CLI reference

| Command             | Description                                                                    |
| ------------------- | ------------------------------------------------------------------------------ |
| `start [ARGS...]`   | Start OmniRoute, wait for health, and launch Hermes with optional arguments.   |
| `stop`              | Send `TERM` to the managed Hermes process, then gracefully stop OmniRoute.     |
| `restart [ARGS...]` | Stop both services and launch them again.                                      |
| `status`            | Show container health, API reachability, active model, and isolated home path. |
| `logs [ARGS...]`    | Follow OmniRoute logs; extra arguments are passed to `docker logs`.            |
| `update`            | Pull the latest official OmniRoute image.                                      |
| `clean`             | Remove the runtime container and PID state while preserving `data/`.           |
| `--help`            | Display command help.                                                          |
| `--version`         | Display the HermesUnchained version.                                           |

The Makefile exposes the common workflow through `make setup`, `make start`, `make stop`,
`make status`, `make logs`, and `make clean`.

## Environment configuration

Copy `.env.example` to `.env` and edit the local values. `.env` is ignored by Git.

| Variable          | Default        | Purpose                                                                        |
| ----------------- | -------------- | ------------------------------------------------------------------------------ |
| `OMNIROUTE_PORT`  | `20128`        | Loopback port for the dashboard and `/v1` API.                                 |
| `DEFAULT_MODEL`   | `auto`         | Model or OmniRoute strategy passed to Hermes.                                  |
| `HERMES_HOME_DIR` | `.hermes-home` | Isolated Hermes state directory; relative paths resolve from this repository.  |
| `DUMMY_KEY`       | `sk-dummy`     | Placeholder key sent to the local gateway. Never use a real provider key here. |

The launcher exports `OPENAI_BASE_URL`, `OPENAI_API_KEY`, and `HERMES_INFERENCE_MODEL`, and
also passes the equivalent explicit arguments to Hermes Agent.

## Operations

```bash
# Check everything
make status

# Follow gateway output (Ctrl-C exits the log stream only)
make logs

# Download the newest OmniRoute image
./bin/hermes-unchained update

# Restart after an image update
./bin/hermes-unchained clean
make start
```

Provider configuration is available from the local dashboard, normally at
<http://localhost:20128>. Runtime data remains under `data/` and is never committed.

## Background service

On Linux systems with a user systemd session, HermesUnchained can run as a supervised
background service. Install and enable the unit from the repository checkout:

```bash
make service-install
make service-start
```

The generated unit contains the checkout's absolute path and is installed at
`~/.config/systemd/user/hermes-unchained.service`. It runs the foreground Hermes process under
systemd, restarts it after failures, and stops both Hermes and OmniRoute during a normal service
shutdown.

Use the Makefile shortcuts for routine management:

```bash
make service-stop       # Stop Hermes and OmniRoute
make service-start      # Start them in the background
make service-logs       # Follow logs from the user journal
systemctl --user status hermes-unchained.service
```

To preview the rendered unit without installing it, run:

```bash
./bin/hermes-unchained install-service --dry-run
```

## Security model

- The gateway port binds only to `127.0.0.1`.
- Hermes uses an isolated `HOME` and XDG directories inside this repository.
- Real credentials, `.env`, runtime PID files, databases, and Hermes state are Git-ignored.
- `.env` is sourced as shell configuration; only use a file you trust and control.

See [CONTRIBUTING.md](CONTRIBUTING.md) to propose improvements. This project is available
under the [MIT License](LICENSE).
