# Script untuk meng-clone repo-repo OCA (Odoo Community Association)
# branch 17.0 ke folder ..\addons. Jika repo tidak punya branch 17.0,
# otomatis fallback ke branch default.
#
# Cara pakai:  powershell -ExecutionPolicy Bypass -File scripts\clone_oca.ps1

$ErrorActionPreference = 'Continue'

$repos = @(
  # Manufaktur & Quality (modul quality_control_oca ada di dalam repo manufacture)
  'OCA/manufacture',
  'OCA/maintenance',
  # Akuntansi & Keuangan
  'OCA/account-financial-reporting',
  'OCA/account-budgeting',
  'OCA/account-payment',
  'OCA/bank-payment',
  'OCA/server-tools',
  'OCA/reporting-engine',
  # Catatan: OCA/l10n-indonesia branch 17.0 kosong, tidak di-clone.
  # Gudang, Logistik & Purchasing
  'OCA/stock-logistics-warehouse',
  'OCA/stock-logistics-workflow',
  'OCA/stock-logistics-transport',
  'OCA/stock-logistics-barcode',
  'OCA/purchase-workflow',
  # CRM, Sales & E-commerce
  'OCA/crm',
  'OCA/sale-workflow',
  'OCA/e-commerce',
  # HR & Payroll
  'OCA/hr',
  'OCA/payroll',
  # Proyek, Timesheet & Helpdesk
  'OCA/project',
  'OCA/timesheet',
  'OCA/helpdesk',
  # Dokumen & Produk
  'OCA/dms',
  'OCA/product-attribute',
  'OCA/partner-contact',
  # Tools web & UI
  'OCA/web'
)

$addonsDir = Join-Path (Split-Path $PSScriptRoot -Parent) 'addons'
New-Item -ItemType Directory -Force -Path $addonsDir | Out-Null

$ok = 0; $skip = 0; $fail = @()

foreach ($repo in $repos) {
  $name = ($repo -split '/')[-1]
  $target = Join-Path $addonsDir $name

  if (Test-Path $target) {
    Write-Host "[SKIP] $name sudah ada"
    $skip++
    continue
  }

  Write-Host "[CLONE] $repo (branch 17.0) ..."
  git clone --quiet --depth 1 --branch 17.0 "https://github.com/$repo.git" $target
  if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK]    $name"
    $ok++
    continue
  }

  # Fallback ke branch default (repo yang tidak punya 17.0)
  if (Test-Path $target) { Remove-Item -Recurse -Force $target }
  Write-Host "[FALLBACK] $name -> branch default ..."
  git clone --quiet --depth 1 "https://github.com/$repo.git" $target
  if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK]    $name (default branch)"
    $ok++
  } else {
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Write-Host "[FAIL]  $repo"
    $fail += $repo
  }
}

Write-Host ""
Write-Host "=== RINGKASAN ==="
Write-Host "Berhasil : $ok"
Write-Host "Skip     : $skip"
if ($fail.Count -gt 0) { Write-Host "Gagal    : $($fail -join ', ')" }
else { Write-Host "Gagal    : 0" }