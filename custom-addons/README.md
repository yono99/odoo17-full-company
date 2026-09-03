# Folder ini untuk modul Odoo buatan sendiri (custom module).
# Setiap modul adalah subfolder berisi __manifest__.py, misalnya:
#
#   custom-addons/
#     my_manufacturing_ext/
#       __manifest__.py
#       models/
#       views/
#       ...
#
# Setelah menambah modul baru, cukup restart container web:
#   docker compose restart web
# Lalu install modulnya lewat menu Apps di Odoo.