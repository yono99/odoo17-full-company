# l10n_id_hr_payroll — Lokalisasi Payroll Indonesia untuk Odoo 17

Modul **custom (gratis, LGPL-3)** pengganti payroll lokal Indonesia yang tidak
tersedia di Odoo Community maupun OCA untuk versi 17. Bergantung pada modul
`payroll` (OCA, sudah ada di `addons/payroll`).

## Yang dihitung (per bulan)

| Komponen | Tarif | Ditanggung | Kategori |
|---|---|---|---|
| Gaji Pokok | dari `contract.wage` | — | ID_BASIC |
| Tunjangan Tetap | input manual per slip | — | ID_ALW |
| **Penghasilan Bruto** | pokok + tunjangan | — | ID_GROSS |
| BPJS Kesehatan | 1% (batas upah, default Rp12jt) | Karyawan | ID_DED |
| JHT | 2% (batas upah, default Rp10jt) | Karyawan | ID_DED |
| JP | 1% | Karyawan | ID_DED |
| **PPh 21** | metode tahunan, tarif 5–35% (UU HPP) | Karyawan | ID_DED |
| BPJS Kesehatan | 4% | Perusahaan | ID_COMP* |
| JHT | 3.7% | Perusahaan | ID_COMP* |
| JP | 2% | Perusahaan | ID_COMP* |
| JKK | 0.24–1.74% sesuai risiko (default 0.54%) | Perusahaan | ID_COMP* |
| JKM | 0.3% | Perusahaan | ID_COMP* |
| **Gaji Bersih** | bruto − potongan | — | ID_NET |

\* iuran perusahaan hanya **informasi** (tidak tampil di slip, tidak mengurangi
gaji bersih) — untuk laporan beban gaji perusahaan.

## Cara pakai

1. Install modul `l10n_id_hr_payroll` lewat menu **Apps** (pastikan `payroll`
   OCA sudah ter-install lebih dulu).
2. **Pengaturan → Payroll Indonesia**: isi batas upah BPJS Kesehatan &
   Ketenagakerjaan sesuai ketetapan berlaku.
3. **Karyawan → tab "Payroll Indonesia"**: isi NPWP, status PTKP, nomor BPJS,
   dan tarif JKK.
4. Buat **kontrak** karyawan dengan gaji pokok (`wage`).
5. Buat payslip: pilih struktur **"Struktur Gaji Bulanan Indonesia"**, isi
   Tunjangan Tetap di tab **Inputs** bila ada, lalu **Compute Sheet**.

## Rumus PPh 21 (v1 — metode tahunan klasik)

```
Penghasilan bruto setahun      = (pokok + tunjangan) × 12
− Iuran BPJS karyawan setahun  = (BPJS Kes 1% + JHT 2% + JP 1%) × 12
− PTKP (sesuai status)         = Rp54jt (TK/0) + Rp4,5jt per tanggungan
= Penghasilan Kena Pajak (PKP)
PPh 21 setahun = 5% s.d. 60jt | 15% s.d. 250jt | 25% s.d. 500jt |
                 30% s.d. 5M | 35% di atas 5M
PPh 21 bulanan  = PPh 21 setahun ÷ 12
Tanpa NPWP → PPh 21 × 120%
```

## ⚠️ Catatan & batasan v1 (perlu validasi akuntan/praktisi pajak)

- **Belum memakai Tarif Efektif Rata-rata (TER)** yang resmi berlaku sejak
  Januari 2024 (PMK 168/2023). Struktur rule sudah siap diganti: cukup ganti
  isi `amount_python_compute` rule `rule_pph21`.
- Belum menangani: lembur, ketidakhadiran/potongan harian, THR & bonus,
  pesangon, natura, dan perhitungan prorata bulan pertama/terakhir.
- Nilai batas upah BPJS ditetapkan ulang tiap tahun — selalu cek ketetapan
  terbaru BPJS Kesehatan & BPJS Ketenagakerjaan.
- Tarif JKK default 0.54% — sesuaikan dengan kelas risiko perusahaan
  (0.24% s.d. 1.74%).
- Uji dengan data riil & bandingkan dengan kalkulator PPh 21 resmi sebelum
  dipakai produksi.

## Struktur file

```
l10n_id_hr_payroll/
├── __manifest__.py
├── models/
│   ├── hr_employee.py        # NPWP, status PTKP, nomor & tarif BPJS
│   ├── res_company.py        # batas upah BPJS per perusahaan
│   ├── res_config_settings.py# pengaturan (Settings)
│   └── hr_payslip.py         # suntik konfigurasi ke engine rule payroll
├── data/payroll_data.xml     # kategori, 13 rule, struktur gaji
└── views/                    # form karyawan & halaman settings
```
