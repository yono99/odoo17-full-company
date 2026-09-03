# Odoo 17 Community + ekosistem OCA untuk kebutuhan 1 perusahaan manufaktur
FROM odoo:17

USER root

# Dependency Python yang umum dibutuhkan modul-modul OCA
# (laporan Excel, barcode, terbilang, telepon, dll)
RUN pip install --no-cache-dir \
    xlwt \
    xlsxwriter \
    unidecode \
    phonenumbers \
    python-barcode \
    stdnum \
    vobject \
    num2words \
    openpyxl

# Entrypoint kustom: membangun addons_path otomatis dari semua repo di /mnt/extra-addons
COPY entrypoint-oca.sh /entrypoint-oca.sh
RUN chmod +x /entrypoint-oca.sh

USER odoo

ENTRYPOINT ["/entrypoint-oca.sh"]