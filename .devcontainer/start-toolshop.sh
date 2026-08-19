#!/usr/bin/env bash
# Starts the self-hosted ToolShop instance every time the Codespace opens
# or resumes. Never fails the Codespace startup — just warns.
set -uo pipefail

TOOLSHOP_DIR="/workspaces/toolshop-selfhost"

if [ ! -d "$TOOLSHOP_DIR" ]; then
  echo "[toolshop] $TOOLSHOP_DIR not found — skipping auto-start."
  exit 0
fi

cd "$TOOLSHOP_DIR" || exit 0

# Note: do NOT touch .env here. This repo's .env is versioned in git with
# SPRINT=sprint5 (defines the laravel-api/angular-ui image names) —
# overwriting it breaks those image pulls. We always pass explicit -f
# flags instead of relying on COMPOSE_FILE in .env.
COMPOSE="docker compose -f docker-compose.prod.yml -f docker-compose.local-build.yml"

echo "[toolshop] Starting containers..."
$COMPOSE up -d

echo "[toolshop] Waiting for the site to respond (up to 90s)..."
for i in $(seq 1 30); do
  if curl -sf -o /dev/null http://localhost:4200 && curl -sf -o /dev/null http://localhost:8091/products; then
    echo "[toolshop] Ready — 4200 (UI) and 8091 (API) responding."
    exit 0
  fi
  sleep 3
done

echo "[toolshop] WARNING: did not respond in time (90s). Check with:"
echo "  $COMPOSE logs --tail=100 angular-ui web"
exit 0
