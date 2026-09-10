# HermesUnchained - Customized by xDweeb

### A self-hosted AI coding environment powered by OmniRoute

[![CI](https://github.com/xDweeb/HermesUnchained/actions/workflows/ci.yml/badge.svg)](https://github.com/xDweeb/HermesUnchained/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/xDweeb/HermesUnchained)](LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/diegosouzapw/omniroute?logo=docker)](https://hub.docker.com/r/diegosouzapw/omniroute)
[![Architecture](https://img.shields.io/badge/architecture-local--first-7C3AED)](#architecture)
[![Aider](https://img.shields.io/badge/Aider-enabled-5A67D8)](#aider-autonomous-coding)
[![Shell](https://img.shields.io/badge/shell-Bash-4EAA25?logo=gnubash&logoColor=white)](scripts/ops/hermes-unchained)

HermesUnchained brings powerful coding agents to a private, local-first workflow. It connects
interactive Hermes chat, the official Claude Code CLI, Aider, and supported VS Code extensions to
the local [OmniRoute](https://github.com/diegosouzapw/OmniRoute) gateway. OmniRoute then routes
OpenAI-compatible requests across 356 inference providers, including free-model options and
automatic fallback strategies.

The result is one reproducible environment for terminal assistance, autonomous repository edits,
Git-aware coding, specialist context, and IDE integration—without binding the gateway to a public
network interface.

Maintained by **Taibi El Yakouti ([@xDweeb](https://github.com/xDweeb))**.

## Why HermesUnchained?

- **One local gateway:** CLI and IDE clients connect through `http://localhost:20128/v1`.
- **Flexible inference:** OmniRoute selects configured models and providers through the `auto`
  routing model.
- **Elite coding agents:** choose Hermes, Claude Code, or open-source Aider for each workflow.
- **Smart context:** launch Aider with focused web, backend, data, CTF, or robotics guidance.
- **Expert skill files:** generate reusable frontend, backend, and cybersecurity instructions.
- **Local-first operation:** the gateway binds to loopback and stores runtime state locally.
- **Operational tooling:** health checks, logs, upgrades, cleanup, log rotation, and an optional
  user-level systemd service are included.

## Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│                     Developer Interfaces                    │
│  Hermes Chat  │  Claude Code  │  Aider  │  Cline/Continue  │
└───────────────┴───────────────┴─────────┴─────────┬─────────┘
                                                   │
                                      OpenAI-compatible API
                                                   │
                                                   ▼
                                 ┌───────────────────────────┐
                                 │  OmniRoute local gateway  │
                                 │  localhost:20128/v1       │
                                 └─────────────┬─────────────┘
                                               │ routing and fallback
                                               ▼
                                 ┌───────────────────────────┐
                                 │ Configured AI providers   │
                                 │ Free and paid inference   │
                                 └───────────────────────────┘
```

OmniRoute runs in a dedicated Docker container, binds to `127.0.0.1`, and persists its state under
`data/`. Hermes uses a repository-local home directory by default, keeping the user's normal
Hermes configuration independent.

## Quick Start

### Requirements

- Linux or macOS with Bash 4+
- Docker Engine with an accessible daemon
- `curl`
- `hermes-agent` on `PATH`
- Node.js and npm only when Claude Code must be installed automatically

Clone the repository and prepare the environment:

```bash
git clone https://github.com/xDweeb/HermesUnchained.git
cd HermesUnchained
make setup
```

Start with an interactive Hermes conversation:

```bash
make chat
```

`make setup` creates an ignored `.env` from `.env.example` when necessary and verifies the core
runtime dependencies. The launcher starts OmniRoute, waits for its health endpoint, and then opens
the selected agent.

## Core Commands

### Hermes terminal chat

```bash
make chat
```

Launches the persistent, interactive Hermes terminal interface through OmniRoute. Hermes runs with
isolated HOME and XDG directories inside `.hermes-home/`.

For a single non-interactive task, provide an explicit prompt:

```bash
make start PROMPT="Review the request routing pipeline"
```

### Claude Code

```bash
make claude
```

Launches the official Claude Code CLI through the local OmniRoute bridge. If `claude` is missing,
the launcher installs `@anthropic-ai/claude-code` globally with npm. Additional Claude arguments
can be supplied through the direct launcher:

```bash
./bin/hermes-unchained claude --help
```

### Aider autonomous coding

```bash
make aider
```

Launches open-source Aider with `openai/auto`, pointing it at the local OmniRoute API. Aider can
inspect and edit repository files while maintaining its Git-aware commit workflow. If Aider is not
installed, HermesUnchained runs Aider's official installer and detects the binary under
`~/.local/bin`.

Pass additional Aider options directly when needed:

```bash
./bin/hermes-unchained aider --help
```

The root [`.aiderignore`](.aiderignore) keeps dependencies, build artifacts, caches, generated
assets, runtime data, and duplicated localization files out of Aider's repository map.

## Smart Context Modes

Set `MODE` when launching Aider to prime the session with domain-specific guidance. Recognized
modes preserve the standard `openai/auto` routing behavior.

| Mode     | Command                    | Focus                                                                  |
| -------- | -------------------------- | ---------------------------------------------------------------------- |
| Web      | `make aider MODE=web`      | React, TypeScript, Vite, Tailwind CSS, Astro, accessibility, and UI/UX |
| Backend  | `make aider MODE=backend`  | Python, FastAPI, Supabase, secure APIs, and backend architecture       |
| Data     | `make aider MODE=data`     | Python, Pandas, Plotly Dash, machine learning, and data pipelines      |
| CTF      | `make aider MODE=ctf`      | Authorized cybersecurity, reverse engineering, binaries, and traffic   |
| Robotics | `make aider MODE=robotics` | Arduino, ESP32, PID control, and C/C++ hardware logic                  |

Examples:

```bash
# Build an accessible React and Tailwind interface
make aider MODE=web

# Review a FastAPI and Supabase service
make aider MODE=backend

# Analyze a Pandas pipeline or Plotly Dash application
make aider MODE=data

# Work in an authorized CTF or isolated security lab
make aider MODE=ctf

# Develop ESP32 firmware or tune a PID controller
make aider MODE=robotics
```

Web, backend/data, and CTF modes also load their corresponding expert Markdown file from
`skills/`. Robotics uses its concise built-in context message. An omitted or unrecognized `MODE`
starts Aider normally without adding a mode message or expert file.

## Advanced Tooling

### VS Code integration generator

```bash
make setup-ide
```

Generates `ide-config-guide.md` in the repository root. The guide provides step-by-step Cline and
Continue.dev setup instructions with exact OpenAI-compatible JSON examples for:

```text
Base URL: http://localhost:20128/v1
API key:  sk-dummy
Model:    auto
```

Open the generated guide and follow the section for the extension you use.

### Aider skills and automation

```bash
make setup-skills
```

Generates `.aider.conf.yml` and refreshes the expert instruction files in `skills/`. The Aider
configuration enables automatic linting and testing while keeping the repository map compact:

```yaml
auto-lint: true
lint-cmd: "python -m flake8" # fallback for python
auto-test: true
map-tokens: 1024
```

The generated expert files are:

- [`skills/frontend-expert.md`](skills/frontend-expert.md) for React, Vite, TypeScript, Tailwind
  CSS, Astro, accessibility, and UI/UX.
- [`skills/backend-expert.md`](skills/backend-expert.md) for Python, FastAPI, Supabase, analytics,
  data pipelines, and secure API design.
- [`skills/ctf-expert.md`](skills/ctf-expert.md) for authorized cybersecurity analysis, reverse
  engineering, binary inspection, and network traffic investigation.

Run `make setup-skills` after cloning if you want the shared Aider automation configuration. The
command is idempotent and can regenerate the files at any time.

## Command Reference

| Make command            | Purpose                                                     |
| ----------------------- | ----------------------------------------------------------- |
| `make setup`            | Create `.env` if needed and verify core dependencies        |
| `make chat`             | Start an interactive Hermes conversation                    |
| `make start PROMPT="…"` | Run one explicit Hermes prompt and exit                     |
| `make claude`           | Launch Claude Code through OmniRoute                        |
| `make aider`            | Launch Aider through OmniRoute                              |
| `make setup-ide`        | Generate the Cline and Continue.dev integration guide       |
| `make setup-skills`     | Generate Aider automation and expert context files          |
| `make status`           | Show runtime, health, and configuration status              |
| `make logs`             | Follow OmniRoute container logs                             |
| `make rotate-logs`      | Compress old Hermes logs and remove expired files           |
| `make stop`             | Gracefully stop Hermes and OmniRoute                        |
| `make clean`            | Remove runtime container/PID state while preserving `data/` |
| `make service-install`  | Install and enable the user-level systemd unit              |
| `make service-start`    | Start HermesUnchained as a background user service          |
| `make service-stop`     | Stop the background user service                            |
| `make service-logs`     | Follow logs from the user systemd journal                   |

Every command is also available through `./bin/hermes-unchained`. Run the launcher with `--help`
for its complete direct-command reference.

## Configuration

Copy `.env.example` to `.env` to customize the local runtime. `make setup` performs this step
automatically when `.env` does not exist.

| Variable          | Default        | Purpose                                                                       |
| ----------------- | -------------- | ----------------------------------------------------------------------------- |
| `OMNIROUTE_PORT`  | `20128`        | Loopback port used by the OmniRoute dashboard and API                         |
| `DEFAULT_MODEL`   | `auto`         | Model or OmniRoute strategy passed to Hermes                                  |
| `HERMES_HOME_DIR` | `.hermes-home` | Isolated Hermes state directory; relative paths resolve from the project root |
| `DUMMY_KEY`       | `sk-dummy`     | Placeholder accepted by the local gateway; do not replace it with a real key  |

The Aider and Claude launchers intentionally use the local bridge at port `20128`. Provider
credentials belong in OmniRoute, not in the client-side placeholder key.

## Operations

Check health and follow gateway activity:

```bash
make status
make logs
```

Pull the latest OmniRoute container image and restart cleanly:

```bash
./bin/hermes-unchained update
make clean
make chat
```

The OmniRoute dashboard is available at <http://localhost:20128> while the gateway is running.
Persistent gateway state remains under `data/`.

### Background service

On Linux with a user systemd session:

```bash
make service-install
make service-start
make service-logs
```

The generated unit is installed at `~/.config/systemd/user/hermes-unchained.service`. Preview it
without installing:

```bash
./bin/hermes-unchained install-service --dry-run
```

Hermes file logs are stored under `.hermes-home/.hermes/logs` by default. `make rotate-logs`
compresses files older than three days and deletes files older than 14 days. Journal output follows
the host's systemd-journald retention policy.

## Security Model

- OmniRoute binds to `127.0.0.1`; it is not exposed on every network interface.
- Hermes runtime state and XDG directories are isolated under `.hermes-home/` by default.
- Real provider credentials remain behind OmniRoute and are not passed to Aider or IDE clients.
- `.env`, runtime state, databases, generated Aider configuration, and logs are ignored by Git.
- CTF guidance is intended only for authorized challenges, isolated labs, and systems you have
  explicit permission to test.
- `.env` is sourced as shell configuration; only use a file you trust and control.

## Troubleshooting

### The gateway does not become healthy

```bash
make status
make logs
```

Confirm Docker is running and port `20128` is available. The launcher waits up to 60 seconds for
the health endpoint before reporting failure.

### Aider is not found after installation

The launcher adds `~/.local/bin` to `PATH` for the current process and also checks
`~/.local/bin/aider` explicitly. Open a new shell or add that directory to your persistent shell
configuration if you want to invoke `aider` directly.

### Aider does not load an expert file

Run `make setup-skills`, then launch from the repository root with a recognized mode such as
`make aider MODE=backend`.

### Reset local runtime state

```bash
make clean
```

This removes the runtime container and PID state but preserves the persistent `data/` directory.

## Contributing and License

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup, testing, and contribution guidance.
Security issues should follow [SECURITY.md](SECURITY.md). HermesUnchained is available under the
[MIT License](LICENSE).
