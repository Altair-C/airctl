#!/usr/bin/env bash
set -euo pipefail

USERS_DB="/etc/airport/users.json"
PORT="8443"

username="${1:-}"

if [ -z "$username" ]; then
  read -rp "请输入用户名: " username
fi

password="$(jq -r --arg u "$username" '.[$u].password // empty' "$USERS_DB")"

if [ -z "$password" ]; then
  echo "用户不存在: $username"
  exit 1
fi

server_ip="$(curl -fsS https://api.ipify.org || hostname -I | awk '{print $1}')"

echo
echo "Shadowrocket / sing-box 导入链接:"
echo "hy2://${username}:${password}@${server_ip}:${PORT}/?sni=bing.com&insecure=1#${username}"
echo
