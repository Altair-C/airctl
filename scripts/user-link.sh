#!/usr/bin/env bash
set -euo pipefail

source /opt/airctl/lib/users.sh
source /opt/airctl/lib/config.sh

ensure_users_db
migrate_users_db
ensure_airctl_config

username="${1:-}"

if [ -z "$username" ]; then
  read -rp "请输入用户名: " username
fi

if ! user_exists "$username"; then
  echo "用户不存在: $username"
  exit 1
fi

password="$(user_password "$username")"
server_ip="$(curl -fsS https://api.ipify.org || hostname -I | awk '{print $1}')"
port="$(config_get_port)"
sni="$(config_get_sni)"

echo
echo "Hysteria2 / Shadowrocket 导入链接:"
echo "hy2://${username}:${password}@${server_ip}:${port}/?sni=${sni}&insecure=1#${username}"
echo
