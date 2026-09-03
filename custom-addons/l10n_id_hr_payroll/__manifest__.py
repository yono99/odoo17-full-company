{
    "name": "Indonesian Payroll Localization (PPh 21, BPJS)",
    "version": "17.0.1.0.0",
    "category": "Payroll Localization",
    "summary": "Struktur gaji Indonesia: PPh 21, BPJS Kesehatan & BPJS Ketenagakerjaan",
    "author": "Freebuff / Custom",
    "license": "LGPL-3",
    "depends": [
        "payroll",
        "hr_contract",
    ],
    "data": [
        "data/payroll_data.xml",
        "views/hr_employee_views.xml",
        "views/res_config_settings_views.xml",
    ],
    "installable": True,
    "application": False,
    "auto_install": False,
}