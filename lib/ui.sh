#!/usr/bin/env bash

RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
WHITE="\033[37m"

BRIGHT_RED="\033[91m"
BRIGHT_GREEN="\033[92m"
BRIGHT_YELLOW="\033[93m"
BRIGHT_BLUE="\033[94m"
BRIGHT_CYAN="\033[96m"
BRIGHT_WHITE="\033[97m"

line() {
  echo -e "${DIM}────────────────────────────────────────────────────────────${RESET}"
}

logo() {
  echo -e "${BRIGHT_CYAN}"
  cat <<'LOGO'
    _    _                       _
   / \  (_) _ __  _ __    ___   | |_
  / _ \ | || '__|| '_ \  / _ \  | __|
 / ___ \| || |   | |_) || (_) | | |_
/_/   \_\_||_|   | .__/  \___/   \__|
                  |_|
LOGO
  echo -e "${RESET}"
}

title() {
  local version="$1"

  echo -e "${BOLD}${BRIGHT_WHITE}Airport Deploy ${BRIGHT_GREEN}v${version}${RESET}"
  line
}

section() {
  local icon="$1"
  local title="$2"
  local color="$3"

  echo
  echo -e "${color}${icon} ${title}${RESET}"
  line
}

item() {
  local num="$1"
  local text="$2"

  printf " ${BRIGHT_GREEN}%3s${RESET}. ${BRIGHT_WHITE}%s${RESET}\n" "$num" "$text"
}

success() {
  echo -e "${BRIGHT_GREEN}✓ $*${RESET}"
}

warning() {
  echo -e "${BRIGHT_YELLOW}⚠ $*${RESET}"
}

error() {
  echo -e "${BRIGHT_RED}✗ $*${RESET}"
}

info() {
  echo -e "${BRIGHT_CYAN}ℹ $*${RESET}"
}
