#!/usr/bin/env bash
set -euo pipefail

source /opt/airctl/lib/config.sh

USERS_DB="/etc/airctl/users.json"
HYSTERIA_CONFIG="/etc/hysteria/config.yaml"

ensure_airctl_config

PORT="$(config_get_port)"
SNI="$(config_get_sni)"
MASQUERADE="$(config_get_masquerade)"
CERT_PATH="$(config_get_cert)"
KEY_PATH="$(config_get_key)"

mkdir -p "$(dirname "$CERT_PATH")"

if [ ! -f "$CERT_PATH" ] || [ ! -f "$KEY_PATH" ]; then
  openssl req -x509 -newkey rsa:2048 \
    -keyout "$KEY_PATH" \
    -out "$CERT_PATH" \
    -days 3650 -nodes \
    -subj "/CN=${SNI}"
fi

chown -R root:hysteria "$(dirname "$CERT_PATH")" 2>/dev/null || true
chmod 750 "$(dirname "$CERT_PATH")"
chmod 640 "$CERT_PATH" "$KEY_PATH"

cat > "$HYSTERIA_CONFIG" <<EOF_CONFIG
listen: :${PORT}

tls:
  cert: ${CERT_PATH}
  key: ${KEY_PATH}

auth:
  type: userpass
  userpass:
EOF_CONFIG

jq -r 'to_entries[] | select(.value.enabled != false) | "    \(.key): \(.value.password)"' "$USERS_DB" >> "$HYSTERIA_CONFIG"

cat >> "$HYSTERIA_CONFIG" <<EOF_CONFIG

masquerade:
  type: proxy
  proxy:
    url: ${MASQUERADE}
    rewriteHost: true
EOF_CONFIG

chown root:hysteria "$HYSTERIA_CONFIG" 2>/dev/null || true
chmod 640 "$HYSTERIA_CONFIG"
