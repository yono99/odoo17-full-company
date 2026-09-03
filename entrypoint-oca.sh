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
HTTP_ARGS=""
if [ -n "$RENDER_PORT" ]; then
  HTTP_ARGS="--http-port=$RENDER_PORT"
fi

# Buang argumen CMD default image ("odoo") agar tidak dobel
if [ "$1" = "odoo" ]; then
  shift
fi

DB_HOST="${NEON_HOST:-${HOST:-}}"
DB_PORT="${NEON_PORT:-5432}"
DB_USER="${NEON_USER:-${USER:-odoo}}"
DB_PASS="${NEON_PASSWORD:-${PASSWORD:-}}"

if [ -n "$DB_HOST" ]; then
  # Cloud (Render): jalankan odoo LANGSUNG dengan argumen db eksplisit.
  # JANGAN lewat /entrypoint.sh resmi — dia selalu menambahkan
  # --db_host default 'db' SETELAH argumen kita dan menimpanya.
  echo "==> DB eksternal: ${DB_HOST}:${DB_PORT} (user: ${DB_USER})"
  exec odoo \
    --config=/etc/odoo/odoo.conf \
    --addons-path="$ADDONS_PATH" \
    --db_host="$DB_HOST" \
    --db_port="$DB_PORT" \
    --db_user="$DB_USER" \
    --db_password="$DB_PASS" \
    --db_sslmode=require \
    $HTTP_ARGS "$@"
fi

# Lokal (docker compose): entrypoint resmi aman dipakai —
# default HOST='db' cocok dengan nama service postgres di compose.
echo "==> DB lokal (docker compose), pakai entrypoint resmi"
exec /entrypoint.sh --addons-path="$ADDONS_PATH" $HTTP_ARGS "$@"