# Copyright 2026 Freebuff / Custom
# License LGPL-3.0 or later (https://www.gnu.org/licenses/lgpl.html).

from odoo import fields, models

# Status Perkawinan untuk Penghasilan Tidak Kena Pajak (PTKP)
# Format: TK = Tidak Kawin, K = Kawin; angka = jumlah tanggungan (maks 3)
PTKP_STATUS = [
    ("TK0", "Tidak Kawin / 0 tanggungan"),
    ("TK1", "Tidak Kawin / 1 tanggungan"),
    ("TK2", "Tidak Kawin / 2 tanggungan"),
    ("TK3", "Tidak Kawin / 3 tanggungan"),
    ("K0", "Kawin / 0 tanggungan"),
    ("K1", "Kawin / 1 tanggungan"),
    ("K2", "Kawin / 2 tanggungan"),
    ("K3", "Kawin / 3 tanggungan"),
]


class HrEmployee(models.Model):
    _inherit = "hr.employee"

    l10n_id_npwp = fields.Char(
        string="NPWP",
        help="Nomor Pokok Wajib Pajak. Jika kosong, PPh 21 dikenakan 20% lebih "
        "tinggi (tanpa NPWP).",
    )
    l10n_id_ptkp_status = fields.Selection(
        PTKP_STATUS,
        string="Status PTKP",
        default="TK0",
        help="Status untuk Penghasilan Tidak Kena Pajak (PPh 21).",
    )
    l10n_id_bpjs_kesehatan_no = fields.Char(
        string="No. BPJS Kesehatan",
        help="Nomor peserta BPJS Kesehatan (biasanya 11 digit).",
    )
    l10n_id_bpjs_tk_no = fields.Char(
        string="No. BPJS Ketenagakerjaan",
        help="Nomor peserta BPJS Ketenagakerjaan.",
    )
    l10n_id_jkk_rate = fields.Float(
        string="Tarif JKK (%)",
        default=0.54,
        digits="Payroll Rate",
        help="Iuran Jaminan Kecelakaan Kerja ditanggung perusahaan, berdasarkan "
        "tingkat risiko: 0.24% (sangat rendah) s.d. 1.74% (sangat tinggi). "
        "Default 0.54% (risiko rendah).",
    )
