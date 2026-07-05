#!/usr/bin/env bash
set -euo pipefail

ss -lunp | grep ':8443' || true
