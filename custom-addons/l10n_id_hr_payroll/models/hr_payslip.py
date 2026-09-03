# Copyright 2026 Freebuff / Custom
# License LGPL-3.0 or later (https://www.gnu.org/licenses/lgpl.html).

from odoo import models


class HrPayslip(models.Model):
    """Suntikkan nilai konfigurasi perusahaan ke localdict rule payroll,
    sehingga rule Python bisa memakai `payroll.bpjs_kesehatan_cap` dan
    `payroll.bpjs_ketenagakerjaan_cap`."""

    _inherit = "hr.payslip"

    def get_payroll_dict(self, contracts):
        res = super().get_payroll_dict(contracts)
        company = contracts[:1].company_id or self.company_id or self.env.company
        res.update(
            {
                "bpjs_kesehatan_cap": (
                    company.l10n_id_bpjs_kesehatan_cap or 12000000.0
                ),
                "bpjs_ketenagakerjaan_cap": (
                    company.l10n_id_bpjs_tk_cap or 10000000.0
                ),
            }
        )
        return res
