#!/usr/bin/env bash
set -euo pipefail

OLD_OPT="/opt/airport"
NEW_OPT="/opt/airctl"
OLD_ETC="/etc/airport"
NEW_ETC="/etc/airctl"

echo "[airctl] Migrating Airport to AirCtl..."

if [ -d "$OLD_OPT" ] && [ ! -d "$NEW_OPT" ]; then
  mv "$OLD_OPT" "$NEW_OPT"
fi

if [ -d "$OLD_ETC" ] && [ ! -d "$NEW_ETC" ]; then
  mv "$OLD_ETC" "$NEW_ETC"
fi

mkdir -p "$NEW_OPT" "$NEW_ETC"

if [ -f "$NEW_OPT/airctl.sh" ]; then
  ln -sf "$NEW_OPT/airctl.sh" /usr/local/bin/airctl
fi

if [ -f /usr/local/bin/airctl ]; then
  ln -sf /usr/local/bin/airctl /usr/local/bin/airport
fi

if [ ! -e "$OLD_OPT" ]; then
  ln -s "$NEW_OPT" "$OLD_OPT"
fi

if [ ! -e "$OLD_ETC" ]; then
  ln -s "$NEW_ETC" "$OLD_ETC"
fi

chmod +x "$NEW_OPT/airctl.sh" 2>/dev/null || true
chmod +x "$NEW_OPT"/scripts/*.sh 2>/dev/null || true
chmod +x "$NEW_OPT"/lib/*.sh 2>/dev/null || true

echo "[airctl] Migration completed."
echo "Run:"
echo "  sudo airctl"
