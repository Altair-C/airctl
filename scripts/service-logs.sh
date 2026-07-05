#!/usr/bin/env bash
set -euo pipefail

journalctl -u hysteria-server -f
