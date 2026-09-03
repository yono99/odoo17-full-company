#!/bin/bash
# Clone repo OCA branch 17.0 ke /opt/odoo-addons — dipakai SAAT BUILD image (Render).
# Local docker memakai addons/ yang sudah di-clone lewat scripts\clone_oca.ps1.
set -e

mkdir -p /opt/odoo-addons
cd /opt/odoo-addons

REPOS="
OCA/manufacture
OCA/maintenance
OCA/account-financial-reporting
OCA/account-budgeting
OCA/account-payment
OCA/bank-payment
OCA/server-tools
OCA/reporting-engine
OCA/stock-logistics-warehouse
OCA/stock-logistics-workflow
OCA/stock-logistics-transport
OCA/stock-logistics-barcode
OCA/purchase-workflow
OCA/crm
OCA/sale-workflow
OCA/e-commerce
OCA/hr
OCA/payroll
OCA/project
OCA/timesheet
OCA/helpdesk
OCA/dms
OCA/product-attribute
OCA/partner-contact
OCA/web
"

for repo in $REPOS; do
  name=$(basename "$repo")
  echo "==> cloning $repo (branch 17.0)"
  if ! git clone --quiet --depth 1 --branch 17.0 "https://github.com/$repo.git" "$name"; then
    echo "==> fallback default branch untuk $name"
    rm -rf "$name"
    git clone --quiet --depth 1 "https://github.com/$repo.git" "$name"
  fi
done

echo "==> selesai: $(ls -d */ | wc -l) repo OCA di /opt/odoo-addons"