#!/usr/bin/env bash
# Clones, builds, and seeds the self-hosted ToolShop instance. Runs from
# postCreateCommand (once per Codespace create/rebuild). Never fails the
# Codespace setup — warns and continues.
set -uo pipefail

TOOLSHOP_DIR="/workspaces/toolshop-selfhost"
COMPOSE="docker compose -f docker-compose.prod.yml -f docker-compose.local-build.yml"

if [ -d "$TOOLSHOP_DIR" ]; then
  echo "[toolshop] $TOOLSHOP_DIR already exists, skipping clone (re-seeding anyway)."
else
  echo "[toolshop] Cloning ToolShop..."
  if ! git clone --quiet https://github.com/testsmith-io/practice-software-testing.git "$TOOLSHOP_DIR"; then
    echo "[toolshop] WARNING: clone failed (no network?). Skipping self-host, rest of the environment still works."
    exit 0
  fi
fi

cd "$TOOLSHOP_DIR" || exit 0

# Local build override: the official "web" and "cron" images are only
# published for arm64, and a Codespace is amd64 — build them from source
# instead of pulling the prebuilt images.
if [ ! -f docker-compose.local-build.yml ]; then
  printf 'services:\n  web:\n    build:\n      context: ./_docker\n      dockerfile: web.docker\n  cron:\n    build:\n      context: ./_docker/cron\n      dockerfile: Dockerfile\n' > docker-compose.local-build.yml
fi

# The repo's .env (versioned in git) already sets SPRINT=sprint5 — required
# for the laravel-api/angular-ui image names. Add it if somehow missing,
# but NEVER overwrite the whole file.
if ! grep -q '^SPRINT=' .env 2>/dev/null; then
  echo "SPRINT=sprint5" >> .env
fi

echo "[toolshop] Building and starting containers (may take a few minutes the first time)..."
$COMPOSE up -d --build

echo "[toolshop] Waiting for the site to respond..."
for i in $(seq 1 40); do
  if curl -sf -o /dev/null http://localhost:4200 && curl -sf -o /dev/null http://localhost:8091/products 2>/dev/null; then
    break
  fi
  sleep 3
done

echo "[toolshop] Seeding database..."
$COMPOSE exec -T laravel-api php artisan migrate:fresh --seed --force
$COMPOSE exec -T -u root laravel-api chown -R www-data:www-data storage bootstrap/cache
$COMPOSE exec -T -u root laravel-api chmod -R 775 storage bootstrap/cache

echo "[toolshop] Ready — self-hosted ToolShop available at localhost:4200 (UI) and localhost:8091 (API)."
exit 0
