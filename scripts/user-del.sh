#!/usr/bin/env bash
set -euo pipefail

source /opt/airctl/lib/users.sh

ensure_users_db
migrate_users_db

read -rp "请输入要删除的用户名: " username

if ! user_exists "$username"; then
  echo "用户不存在: $username"
  exit 1
fi

user_delete "$username"

bash /opt/airctl/scripts/render-config.sh
systemctl restart hysteria-server

echo "用户已删除: $username"
