# Odoo 17 Full Company — Manufaktur, Akuntansi, CRM, HR, Gudang, E-commerce

Satu instalasi Odoo 17 Community + ekosistem modul **OCA (Odoo Community Association)**
yang menutupi seluruh kebutuhan operasional satu perusahaan manufaktur:

| Departemen | Modul unggulan (di folder `addons/`) |
|---|---|
| 🏭 Manufaktur | `mrp`, `mrp_workorder`, `mrp_bom` (core) + `OCA/manufacture` |
| ✅ Quality Control | `quality_control_oca`, `quality_control_mrp_oca`, `quality_control_stock_oca` (di dalam `OCA/manufacture`) |
| 🔧 Maintenance mesin | `maintenance` (core) + `OCA/maintenance` |
| 📊 Akuntansi & Keuangan | `account`, `account_asset`, `account_reports` (core) + `OCA/account-financial-reporting`, `OCA/account-budgeting`, `OCA/account-payment`, `OCA/bank-payment` |
| 🇮🇩 Lokalisasi Indonesia | `l10n_id` (core bawaan image Odoo: kode akun, PPN, PPh) |
| 📦 Gudang & Inventaris | `stock`, `barcode`, `delivery` (core) + `OCA/stock-logistics-warehouse`, `OCA/stock-logistics-workflow`, `OCA/stock-logistics-transport`, `OCA/stock-logistics-barcode` |
| 🛒 Purchasing | `purchase` (core) + `OCA/purchase-workflow` |
| 🤝 CRM & Sales | `crm`, `sale` (core) + `OCA/crm`, `OCA/sale-workflow` |
| 🌐 E-commerce | `website`, `website_sale`, `payment` (core) + `OCA/e-commerce` |
| 👥 HR & Payroll | `hr`, `hr_holidays`, `hr_expense`, `hr_attendance` (core) + `OCA/hr`, `OCA/payroll` |
| 📋 Proyek & Timesheet | `project`, `timesheet_grid` (core) + `OCA/project`, `OCA/timesheet` |
| 🎧 Helpdesk | `OCA/helpdesk` |
| 📁 Manajemen Dokumen | `OCA/dms` |
| 🏷️ Master Produk | `product` (core) + `OCA/product-attribute`, `OCA/partner-contact` |
| 🛠️ Tools & Laporan | `OCA/server-tools`, `OCA/reporting-engine` (laporan Excel), `OCA/web` |

## Alur bisnis yang terhubung (satu database)

```
Lead (CRM) → Sales Order → Manufacturing Order (MRP dari BOM)
    → Stock (material keluar, barang jadi masuk, barcode)
    → Delivery → Invoice (akuntansi + pajak Indonesia) → Payment
    → HR (absensi, cuti, expense) → Payroll (OCA hr-payroll)
```

## Struktur folder

```
odoo17-full-company/
├── docker-compose.yml        # Odoo 17 + PostgreSQL 15
├── Dockerfile                # Image kustom + dependency Python OCA
├── entrypoint-oca.sh         # Bangun addons_path otomatis dari semua repo
├── config/odoo.conf          # Konfigurasi Odoo
├── addons/                   # Hasil clone repo OCA (di-generate, jangan diedit)
├── custom-addons/            # Modul custom milik Anda sendiri
└── scripts/clone_oca.ps1     # Script clone/update semua repo OCA
```

## Cara menjalankan

```bash
# 1. (Sekali saja) clone semua repo OCA branch 17.0
powershell -ExecutionPolicy Bypass -File scripts\clone_oca.ps1

# 2. Bangun image + jalankan
docker compose up -d --build

# 3. Buka browser
#    http://localhost:8069
#    → buat database baru (Master Password: bebas, ingat saja)
#    → masukkan email admin & password
#    → di halaman "Apps", centang modul yang dibutuhkan lalu Install
```

> **PENTING:** Jangan install SEMUA modul sekaligus. Pilih sesuai kebutuhan
> (misal: `Inventory`, `Manufacturing`, `Accounting`, `Sales`, `CRM`, `Employees`,
> `Website`, `eCommerce`) — banyak modul OCA yang saling bergantung dan
> menambah beban. Mulai dari core, lalu tambah modul OCA satu per satu.

## Perintah umum

| Tujuan | Perintah |
|---|---|
| Lihat log Odoo | `docker compose logs -f web` |
| Stop semua | `docker compose down` |
| Hapus semua data (reset) | `docker compose down -v` |
| Update daftar modul | `docker compose restart web` |
| Shell Odoo | `docker compose exec web odoo shell -d NAMA_DB` |
| Install modul via CLI | `docker compose exec web odoo -d NAMA_DB -i NAMA_MODUL` |

## Catatan penting

- **Community vs Enterprise**: modul seperti `quality`, `helpdesk`, `documents`,
  `plm`, `account_budget` aslinya Enterprise (berbayar). Pengganti gratisnya
  disediakan oleh OCA seperti di tabel atas.
- **Payroll Indonesia**: OCA `hr_payroll` (dari `OCA/payroll`) menyediakan engine-nya,
  tapi aturan gaji Indonesia (PPh 21, BPJS, THR) **tidak tersedia gratis untuk Odoo 17**
  (`OCA/l10n-indonesia` 17.0 kosong). Modul `l10n_id_hr_payroll` untuk Odoo 17
  akan dibuat sendiri sebagai custom module di `custom-addons/`.
- Jika ada modul OCA yang butuh dependency Python tambahan, install manual:
  `docker compose exec web pip install NAMA_PACKAGE` lalu restart.
- Semua kredensial dev: database `odoo` / password `odoo` (hanya untuk lokal, ganti untuk produksi).

## Deploy ke Render (gratis / hobby)

Odoo tidak bisa jalan di Vercel/Cloudflare Workers (Python monolitik). Arsitektur cloud:
**Render** (web service Odoo, plan free — tidur saat idle 15 menit) + **Neon PostgreSQL** (free tier).

1. Push repo ke GitHub (folder `addons/` otomatis tidak ikut — di-clone saat build).
2. Buat database di Neon, catat `hostname/user/password`.
3. Buka blueprint Render:
   `https://dashboard.render.com/blueprint/new?repo=<URL-REPO>`
4. Isi env vars `HOST`, `USER`, `PASSWORD` (port 5432) dari Neon, lalu Apply.
5. Buka `https://odoo17-full-company.onrender.com` → buat database → install modul.

File kunci: `render.yaml`, `Dockerfile.render`, `config/odoo.render.conf`,
`scripts/clone_oca_build.sh`.

## Sumber

- [Odoo 17 Community](https://github.com/odoo/odoo/tree/17.0)
- [OCA — Odoo Community Association](https://github.com/OCA)