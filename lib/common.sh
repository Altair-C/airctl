#!/usr/bin/env bash

APP_DIR="/opt/airctl"
VERSION_FILE="${APP_DIR}/VERSION"

get_version() {
  if [ -f "$VERSION_FILE" ]; then
    cat "$VERSION_FILE"
  else
    echo "dev"
  fi
}

get_public_ip() {
  curl -fsS https://api.ipify.org 2>/dev/null || hostname -I | awk '{print $1}'
}

get_user_count() {
  if [ -f /etc/airctl/users.json ]; then
    jq 'length' /etc/airctl/users.json 2>/dev/null || echo "0"
  else
    echo "0"
  fi
}

get_service_status_text() {
  if systemctl is-active --quiet hysteria-server; then
    echo "Running"
  else
    echo "Stopped"
  fi
}

get_service_status_icon() {
  if systemctl is-active --quiet hysteria-server; then
    echo "🟢"
  else
    echo "🔴"
  fi
}

get_hysteria_version() {
  local output

  if command -v hysteria >/dev/null 2>&1; then
    output="$(hysteria version 2>&1 || true)"
  elif [ -x /usr/local/bin/hysteria ]; then
    output="$(/usr/local/bin/hysteria version 2>&1 || true)"
  else
    echo "unknown"
    return
  fi

  echo "$output" | awk -F'\t' '/^Version:/ {print "Hysteria " $2; exit}'
}

pause() {
  echo
  read -rp "按 Enter 返回菜单..."
}
