#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="airport-deploy"

log() {
  echo "[${PROJECT_NAME}] $*"
}

require_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root: sudo ./install.sh"
    exit 1
  fi
}

check_ubuntu_version() {
  . /etc/os-release

  if [ "${ID}" != "ubuntu" ]; then
    echo "Only Ubuntu is supported."
    exit 1
  fi

  log "Detected Ubuntu ${VERSION_ID}"

  if [ "${VERSION_ID}" != "22.04" ]; then
    echo
    echo "WARNING:"
    echo "Hiddify official installer is documented/tested for Ubuntu 22.04."
    echo "Current system is Ubuntu ${VERSION_ID}."
    echo
    echo "Recommended: rebuild server with Ubuntu 22.04 before installing Hiddify."
    echo
    exit 1
  fi
}

install_hiddify() {
  log "Installing Hiddify Manager release..."
  bash <(curl -fsSL https://i.hiddify.com/release)
}

main() {
  require_root
  check_ubuntu_version
  install_hiddify
}

main "$@"
