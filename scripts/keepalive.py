#!/usr/bin/env python3
"""Keep-alive untuk service free Render.

Render free tier menidurkan service setelah ~15 menit tanpa request.
Cron job ini memanggil URL Odoo setiap 10 menit agar service tetap terjaga.
Keluar dengan kode 0 selalu (kegagalan ping tidak masalah — percobaan
berikutnya akan membangunkan service).
"""

import sys
import time
import urllib.request

URL = "https://odoo17-full-company.onrender.com/web/login"


def ping() -> bool:
    req = urllib.request.Request(URL, headers={"User-Agent": "odoo-keepalive"})
    try:
        with urllib.request.urlopen(req, timeout=90) as resp:
            print(f"OK  status={resp.status} url={URL}")
            return True
    except Exception as exc:  # noqa: BLE001 - ping terbaik-effort
        print(f"GAGAL {exc!r}")
        return False


if __name__ == "__main__":
    ok = ping()
    if not ok:
        # Service mungkin sedang bangun (cold start ~1 menit); coba sekali lagi
        time.sleep(30)
        ping()
    sys.exit(0)
