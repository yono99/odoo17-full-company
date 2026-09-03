# Copyright 2026 Freebuff / Custom
# License LGPL-3.0 or later (https://www.gnu.org/licenses/lgpl.html).

from odoo import fields, models


class ResCompany(models.Model):
    _inherit = "res.company"

    l10n_id_bpjs_kesehatan_cap = fields.Float(
        string="Batas Upah BPJS Kesehatan (Rp)",
        default=12000000.0,
        digits="Payroll",
        help="Batas maksimum upah untuk iuran BPJS Kesehatan. "
        "Sesuai peraturan yang berlaku (contoh: Rp12.000.000/bulan).",
    )
    l10n_id_bpjs_tk_cap = fields.Float(
        string="Batas Upah BPJS Ketenagakerjaan (Rp)",
        default=10000000.0,
        digits="Payroll",
        help="Batas maksimum upah untuk iuran JHT, JP, JKK, JKM. "
        "Nilai ini ditetapkan ulang oleh BPJS Ketenagakerjaan setiap tahun "
        "(contoh: ±Rp10.000.000/bulan). Sesuaikan dengan ketetapan berlaku.",
    )
