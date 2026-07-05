#!/usr/bin/env bash

APP_DIR="/opt/airport"
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
  if [ -f /etc/airport/users.json ]; then
    jq 'length' /etc/airport/users.json 2>/dev/null || echo "0"
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
  if command -v hysteria >/dev/null 2>&1; then
    hysteria version 2>&1 | head -n 1
  elif [ -x /usr/local/bin/hysteria ]; then
    /usr/local/bin/hysteria version 2>&1 | head -n 1
  else
    echo "unknown"
  fi
}

pause() {
  echo
  read -rp "按 Enter 返回菜单..."
}
