#!/usr/bin/env bash
set -euo pipefail

USERS_DB="/etc/airport/users.json"
HYSTERIA_CONFIG="/etc/hysteria/config.yaml"
PORT="8443"

cat > "${HYSTERIA_CONFIG}" <<EOF_CONFIG
listen: :${PORT}

tls:
  type: self-signed
  sni: bing.com

auth:
  type: userpass
  userpass:
EOF_CONFIG

jq -r 'to_entries[] | "    \(.key): \(.value.password)"' "${USERS_DB}" >> "${HYSTERIA_CONFIG}"

cat >> "${HYSTERIA_CONFIG}" <<EOF_CONFIG

masquerade:
  type: proxy
  proxy:
    url: https://www.bing.com/
    rewriteHost: true
EOF_CONFIG

chmod 600 "${HYSTERIA_CONFIG}"
