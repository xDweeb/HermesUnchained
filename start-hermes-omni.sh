#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
OMNIROUTE_URL="http://localhost:20128/v1"
HERMES_AGENT_BIN="$(command -v hermes-agent || true)"

if [[ -z "$HERMES_AGENT_BIN" ]]; then
  echo "Error: hermes-agent is not available on PATH." >&2
  exit 1
fi

if ! curl --silent --fail --max-time 3 "http://localhost:20128/healthz" >/dev/null; then
  echo "Error: OmniRoute is not responding at $OMNIROUTE_URL." >&2
  echo "Start it first with: $SCRIPT_DIR/start-omniroute.sh" >&2
  exit 1
fi

# Resolve Hermes before changing HOME, then isolate all runtime state from ~/.hermes.
mkdir -p "$SCRIPT_DIR/.hermes-home"
export HOME="$SCRIPT_DIR/.hermes-home"
export XDG_CONFIG_HOME="$SCRIPT_DIR/.hermes-home/.config"
export XDG_CACHE_HOME="$SCRIPT_DIR/.hermes-home/.cache"
export XDG_DATA_HOME="$SCRIPT_DIR/.hermes-home/.local/share"

export OPENAI_BASE_URL="$OMNIROUTE_URL"
export OPENAI_API_KEY="sk-dummy"
export HERMES_INFERENCE_MODEL="auto"

exec "$HERMES_AGENT_BIN" \
  --base_url="$OPENAI_BASE_URL" \
  --api_key="$OPENAI_API_KEY" \
  --model="$HERMES_INFERENCE_MODEL" \
  "$@"
