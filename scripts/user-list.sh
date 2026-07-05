#!/usr/bin/env bash
set -euo pipefail

USERS_DB="/etc/airport/users.json"

echo "用户列表:"
jq -r 'to_entries[] | "- \(.key)"' "$USERS_DB"
