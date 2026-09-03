#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_NAME="hermes-unchained-omniroute"

mkdir -p "$SCRIPT_DIR/data"

if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
  docker start "$CONTAINER_NAME" >/dev/null
else
  docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    --stop-timeout 40 \
    --publish 127.0.0.1:20128:20128 \
    --volume "$SCRIPT_DIR/data:/app/data" \
    docker.io/diegosouzapw/omniroute:latest >/dev/null
fi

echo "OmniRoute is starting at http://localhost:20128/v1"
echo "Follow logs with: docker logs -f $CONTAINER_NAME"
