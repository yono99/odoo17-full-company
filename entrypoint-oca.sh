#!/bin/bash
set -e

# Bangun addons_path dari semua folder modul:
#   /opt/odoo-addons/*        -> addons OCA di-clone saat build image (Render)
#   /mnt/extra-addons/*       -> addons OCA bind-mount (docker compose lokal)
#   /opt/custom-addons        -> modul custom di dalam image (Render)
#   /mnt/custom-addons        -> modul custom bind-mount (docker compose lokal)
ADDONS_PATH=""
for base in /opt/odoo-addons /mnt/extra-addons; do
  [ -d "$base" ] || continue
  for d in "$base"/*/; do
    [ -d "$d" ] || continue
    if [ -z "$ADDONS_PATH" ]; then
      ADDONS_PATH="${d%/}"
    else
      ADDONS_PATH="$ADDONS_PATH,${d%/}"
    fi
  done
done
for base in /opt/custom-addons /mnt/custom-addons; do
  if [ -d "$base" ]; then
    ADDONS_PATH="$ADDONS_PATH,$base"
  fi
done

echo "==> Odoo addons_path: $ADDONS_PATH"

RENDER_PORT="${PORT:-}"

# Cloud (Render): kredensial DB dikirim lewat env NEON_*.
# Env HOST/PORT/USER/PASSWORD sengaja TIDAK dipakai karena entrypoint resmi
# image odoo memetakannya ke db_* dan Render memakai PORT untuk port HTTP.
DB_ARGS=""
if [ -n "$NEON_HOST" ]; then
  DB_ARGS="--db_host=$NEON_HOST --db_port=${NEON_PORT:-5432} --db_user=${NEON_USER:-odoo} --db_password=$NEON_PASSWORD"
  # Netralkan env yang dibaca entrypoint resmi agar tidak dobel
  unset HOST PORT USER PASSWORD
fi

# Render: service harus mendengarkan di port $PORT (bukan 8069)
HTTP_ARGS=""
if [ -n "$RENDER_PORT" ]; then
  HTTP_ARGS="--http-port=$RENDER_PORT"
fi

exec /entrypoint.sh --addons-path="$ADDONS_PATH" $DB_ARGS $HTTP_ARGS "$@"