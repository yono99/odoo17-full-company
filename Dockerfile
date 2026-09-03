# Odoo 17 Community + OCA untuk Render (juga dipakai Render Blueprint).
# Addons OCA TIDAK di-commit ke git — di-clone saat build image.
# (Image odoo:17 mendeklarasikan VOLUME /mnt/extra-addons, jadi kita clone di
#  /opt/odoo-addons yang bukan volume agar persisten di dalam image.)
FROM odoo:17

USER root

# Git dibutuhkan untuk clone repo OCA saat build
RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

# Dependency Python yang umum dibutuhkan modul-modul OCA
RUN pip install --no-cache-dir \
    xlwt \
    xlsxwriter \
    unidecode \
    phonenumbers \
    python-barcode \
    python-stdnum \
    vobject \
    num2words \
    openpyxl

# Clone seluruh repo OCA (branch 17.0) ke /opt/odoo-addons
COPY scripts/clone_oca_build.sh /opt/clone_oca_build.sh
RUN chmod +x /opt/clone_oca_build.sh && /opt/clone_oca_build.sh

# Entrypoint kustom (addons_path otomatis + dukungan $PORT & env NEON_*)
COPY entrypoint-oca.sh /entrypoint-oca.sh
RUN chmod +x /entrypoint-oca.sh

# Konfigurasi khusus Render (proxy_mode, batas memori untuk plan free)
COPY config/odoo.render.conf /etc/odoo/odoo.conf

# Modul custom (termasuk l10n_id_hr_payroll)
COPY custom-addons /opt/custom-addons

# Pastikan semua bisa dibaca/ditulis proses odoo (user odoo),
# termasuk data_dir untuk disk Render
RUN chown -R odoo:odoo /opt/odoo-addons /opt/custom-addons \
    && mkdir -p /var/lib/odoo && chown -R odoo:odoo /var/lib/odoo

USER odoo

ENTRYPOINT ["/entrypoint-oca.sh"]
