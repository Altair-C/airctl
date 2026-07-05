#!/usr/bin/env bash
set -euo pipefail

AIRCTL_CONFIG="/etc/airctl/config.json"
AIRCTL_CONFIG_TEMPLATE="/opt/airctl/templates/config.json"

ensure_airctl_config() {
  mkdir -p /etc/airctl

  if [ ! -f "$AIRCTL_CONFIG" ]; then
    if [ -f "$AIRCTL_CONFIG_TEMPLATE" ]; then
      cp "$AIRCTL_CONFIG_TEMPLATE" "$AIRCTL_CONFIG"
    else
      cat > "$AIRCTL_CONFIG" <<'JSON'
{
  "server": {
    "port": 8443,
    "sni": "bing.com",
    "masquerade": "https://www.bing.com/"
  },
  "tls": {
    "cert": "/etc/hysteria/certs/server.crt",
    "key": "/etc/hysteria/certs/server.key"
  },
  "paths": {
    "users_db": "/etc/airctl/users.json",
    "output_dir": "/opt/airctl/output"
  }
}
JSON
    fi

    chmod 600 "$AIRCTL_CONFIG"
  fi
}

config_get_port() {
  ensure_airctl_config
  jq -r '.server.port' "$AIRCTL_CONFIG"
}

config_get_sni() {
  ensure_airctl_config
  jq -r '.server.sni' "$AIRCTL_CONFIG"
}

config_get_masquerade() {
  ensure_airctl_config
  jq -r '.server.masquerade' "$AIRCTL_CONFIG"
}

config_get_cert() {
  ensure_airctl_config
  jq -r '.tls.cert' "$AIRCTL_CONFIG"
}

config_get_key() {
  ensure_airctl_config
  jq -r '.tls.key' "$AIRCTL_CONFIG"
}

config_get_output_dir() {
  ensure_airctl_config
  jq -r '.paths.output_dir' "$AIRCTL_CONFIG"
}
