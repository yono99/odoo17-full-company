#!/bin/bash
set -e

# Bangun addons_path dari semua folder modul:
#   /opt/odoo-addons/oca/*  -> addons OCA di-clone saat build image (untuk Render)
#   /mnt/extra-addons/*     -> addons OCA bind-mount (untuk docker compose lokal)
#   /opt/custom-addons      -> modul custom di dalam image (Render)
#   /mnt/custom-addons      -> modul custom bind-mount (docker compose lokal)
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

# Di Render, service harus mendengarkan di port $PORT (bukan 8069)
# Teruskan ke entrypoint resmi image odoo (menangani inisialisasi & env HOST/USER/PASSWORD)
exec /entrypoint.sh --addons-path="$ADDONS_PATH" ${PORT:+--http-port=$PORT} "$@"