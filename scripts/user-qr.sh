#!/usr/bin/env bash
set -euo pipefail

username="${1:-}"

if [ -z "$username" ]; then
  read -rp "请输入用户名: " username
fi

link="$(bash /opt/airport/scripts/user-link.sh "$username" | grep '^hy2://')"

echo "$link"
echo
qrencode -t ANSIUTF8 "$link"
