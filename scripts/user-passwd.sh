#!/usr/bin/env bash
set -euo pipefail

source /opt/airctl/lib/users.sh

ensure_users_db
migrate_users_db

read -rp "请输入用户名: " username

if ! user_exists "$username"; then
  echo "用户不存在: $username"
  exit 1
fi

password="$(openssl rand -base64 18 | tr -d '=+/')"
now="$(date '+%Y-%m-%d %H:%M:%S')"

user_set_password "$username" "$password" "$now"

bash /opt/airctl/scripts/render-config.sh
systemctl restart hysteria-server

echo "密码已修改"
echo "用户: $username"
echo "新密码: $password"
echo
bash /opt/airctl/scripts/user-link.sh "$username"
