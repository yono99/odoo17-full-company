# Copyright 2026 Freebuff / Custom
# License LGPL-3.0 or later (https://www.gnu.org/licenses/lgpl.html).

from odoo import fields, models


class ResConfigSettings(models.TransientModel):
    _inherit = "res.config.settings"

    l10n_id_bpjs_kesehatan_cap = fields.Float(
        related="company_id.l10n_id_bpjs_kesehatan_cap",
        readonly=False,
    )
    l10n_id_bpjs_tk_cap = fields.Float(
        related="company_id.l10n_id_bpjs_tk_cap",
        readonly=False,
    )
