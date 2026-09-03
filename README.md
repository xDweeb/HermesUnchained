# HermesUnchained

This repository runs OmniRoute locally and launches a separate Hermes Agent session against
its OpenAI-compatible endpoint. The launcher does not edit or reuse the normal
`~/.hermes` configuration: its runtime home and cache live in `.hermes-home/` inside this
repository.

## Requirements

- Docker with a running Docker daemon
- `curl`
- Hermes Agent installed and `hermes-agent` available on `PATH`

## Start

1. Start OmniRoute in the background:

   ```bash
   ./start-omniroute.sh
   ```

2. Wait until the dashboard is available at <http://localhost:20128>, then launch Hermes:

   ```bash
   ./start-hermes-omni.sh
   ```

   Extra Hermes Agent arguments are passed through. For example:

   ```bash
   ./start-hermes-omni.sh --max_turns=20
   ```

The Hermes launcher uses:

- Base URL: `http://localhost:20128/v1`
- Model: `auto`
- API key: `sk-dummy` (a local placeholder)

The same values are exported as `OPENAI_BASE_URL`, `HERMES_INFERENCE_MODEL`, and
`OPENAI_API_KEY`, and are also passed as explicit Hermes Agent arguments.

## Configure providers

Open <http://localhost:20128> to configure optional OmniRoute providers. A fresh OmniRoute
installation also includes its keyless default route. OmniRoute data is persisted under
`./data/` and is intentionally ignored by Git.

## Operations

Check status or logs:

```bash
docker ps --filter name=hermes-unchained-omniroute
docker logs -f hermes-unchained-omniroute
```

Stop the service without deleting its data:

```bash
docker stop hermes-unchained-omniroute
```

Restart it later with `./start-omniroute.sh`.

## GitHub preparation

The upstream OmniRoute remote is named `upstream`. The public project remote is `origin`:

```bash
git remote add origin https://github.com/xDweeb/HermesUnchained.git
git push -u origin HEAD
```

Do not commit `.hermes-home/`, `data/`, `.env`, credentials, or API keys.
