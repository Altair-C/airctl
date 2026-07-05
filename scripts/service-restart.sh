#!/usr/bin/env bash
set -euo pipefail

systemctl restart hysteria-server
systemctl status hysteria-server --no-pager
