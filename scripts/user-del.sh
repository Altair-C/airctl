#!/usr/bin/env bash
set -euo pipefail

USERS_DB="/etc/airport/users.json"

read -rp "请输入要删除的用户名: " username

if ! jq -e --arg u "$username" '.[$u]' "$USERS_DB" >/dev/null; then
  echo "用户不存在: $username"
  exit 1
fi

tmp="$(mktemp)"
jq --arg u "$username" 'del(.[$u])' "$USERS_DB" > "$tmp"
cat "$tmp" > "$USERS_DB"
rm -f "$tmp"

bash /opt/airport/scripts/render-config.sh
systemctl restart hysteria-server

echo "用户已删除: $username"
