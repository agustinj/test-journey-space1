#!/usr/bin/env bash
# Clona, arma y siembra ToolShop self-hosteado. Corre desde postCreateCommand
# (una vez por creación/rebuild del Codespace). No falla el setup del
# Codespace si algo sale mal — avisa y sigue.
set -uo pipefail

TOOLSHOP_DIR="/workspaces/toolshop-selfhost"
COMPOSE="docker compose -f docker-compose.prod.yml -f docker-compose.local-build.yml"

if [ -d "$TOOLSHOP_DIR" ]; then
  echo "[toolshop] $TOOLSHOP_DIR ya existe, no se re-clona (se re-siembra la base igual)."
else
  echo "[toolshop] Clonando ToolShop..."
  if ! git clone --quiet https://github.com/testsmith-io/practice-software-testing.git "$TOOLSHOP_DIR"; then
    echo "[toolshop] ATENCIÓN: no se pudo clonar (¿sin red?). Se omite el self-host, el resto del entorno sigue funcionando."
    exit 0
  fi
fi

cd "$TOOLSHOP_DIR" || exit 0

# Override de build local: las imágenes oficiales de "web" y "cron" solo
# están publicadas para arm64, y un Codespace es amd64 — hay que compilarlas
# del código fuente del propio repo en vez de bajarlas ya armadas.
if [ ! -f docker-compose.local-build.yml ]; then
  printf 'services:\n  web:\n    build:\n      context: ./_docker\n      dockerfile: web.docker\n  cron:\n    build:\n      context: ./_docker/cron\n      dockerfile: Dockerfile\n' > docker-compose.local-build.yml
fi

# El .env del repo (versionado en git) ya trae SPRINT=sprint5 — necesario
# para el nombre de las imágenes de laravel-api y angular-ui. Si por algo
# faltara, lo agregamos, pero NUNCA sobreescribimos el archivo entero.
if ! grep -q '^SPRINT=' .env 2>/dev/null; then
  echo "SPRINT=sprint5" >> .env
fi

echo "[toolshop] Construyendo y levantando contenedores (puede tardar unos minutos la primera vez)..."
$COMPOSE up -d --build

echo "[toolshop] Esperando a que el sitio responda..."
for i in $(seq 1 40); do
  if curl -sf -o /dev/null http://localhost:4200 && curl -sf -o /dev/null http://localhost:8091/products 2>/dev/null; then
    break
  fi
  sleep 3
done

echo "[toolshop] Sembrando base de datos..."
$COMPOSE exec -T laravel-api php artisan migrate:fresh --seed --force
$COMPOSE exec -T -u root laravel-api chown -R www-data:www-data storage bootstrap/cache
$COMPOSE exec -T -u root laravel-api chmod -R 775 storage bootstrap/cache

echo "[toolshop] Listo — ToolShop self-hosteado disponible en localhost:4200 (UI) y localhost:8091 (API)."
exit 0
