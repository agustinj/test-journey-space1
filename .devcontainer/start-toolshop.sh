#!/usr/bin/env bash
# Levanta el ToolShop self-hosteado cada vez que se abre/reanuda el Codespace.
# Nunca falla el arranque del Codespace si algo sale mal — solo avisa.
set -uo pipefail

TOOLSHOP_DIR="/workspaces/toolshop-selfhost"

if [ ! -d "$TOOLSHOP_DIR" ]; then
  echo "[toolshop] No se encontró $TOOLSHOP_DIR — se omite el auto-arranque."
  exit 0
fi

cd "$TOOLSHOP_DIR" || exit 0

# Ojo: NO tocar .env acá. El .env de este repo viene versionado en git
# con SPRINT=sprint5 (define el nombre de las imágenes de laravel-api y
# angular-ui) — sobreescribirlo rompe el pull de esas imágenes. Por eso
# pasamos los -f explícitos siempre, en vez de depender de COMPOSE_FILE
# en .env.
COMPOSE="docker compose -f docker-compose.prod.yml -f docker-compose.local-build.yml"

echo "[toolshop] Levantando contenedores..."
$COMPOSE up -d

echo "[toolshop] Esperando a que el sitio responda (hasta 90s)..."
for i in $(seq 1 30); do
  if curl -sf -o /dev/null http://localhost:4200 && curl -sf -o /dev/null http://localhost:8091/products; then
    echo "[toolshop] Listo — 4200 (UI) y 8091 (API) responden."
    exit 0
  fi
  sleep 3
done

echo "[toolshop] ATENCIÓN: no respondió a tiempo (90s). Revisá con:"
echo "  $COMPOSE logs --tail=100 angular-ui web"
exit 0
