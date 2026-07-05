#!/usr/bin/env bash

RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"

BRIGHT_RED="\033[91m"
BRIGHT_GREEN="\033[92m"
BRIGHT_YELLOW="\033[93m"
BRIGHT_BLUE="\033[94m"
BRIGHT_MAGENTA="\033[95m"
BRIGHT_CYAN="\033[96m"
BRIGHT_WHITE="\033[97m"

ui_line() {
  echo -e "${DIM}────────────────────────────────────────────${RESET}"
}

ui_long_line() {
  echo -e "${DIM}────────────────────────────────────────────────────────────${RESET}"
}

ui_logo() {
  echo -e "${BRIGHT_CYAN}"
  cat <<'LOGO'
 █████╗ ██╗██████╗  ██████╗████████╗██╗
██╔══██╗██║██╔══██╗██╔════╝╚══██╔══╝██║
███████║██║██████╔╝██║        ██║   ██║
██╔══██║██║██╔══██╗██║        ██║   ██║
██║  ██║██║██║  ██║╚██████╗   ██║   ███████╗
╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚══════╝
LOGO
  echo -e "${RESET}"
}

ui_header() {
  local version="$1"
  local subtitle="${2:-Private Proxy Management Toolkit}"

  ui_logo
  echo -e "${BOLD}${BRIGHT_WHITE}AirCtl ${BRIGHT_GREEN}v${version}${RESET}"
  echo -e "${DIM}${subtitle}${RESET}"
  ui_long_line
}

ui_page_title() {
  local title="$1"

  echo
  ui_line
  echo -e " ${BOLD}${BRIGHT_WHITE}${title}${RESET}"
  ui_line
}

ui_section() {
  local title="$1"
  local color="${2:-$BRIGHT_CYAN}"

  echo
  echo -e "${color}${title}${RESET}"
  ui_line
}

ui_field() {
  local label="$1"
  local value="$2"

  echo -e " ${BRIGHT_BLUE}${label}${RESET}${BRIGHT_WHITE}${value}${RESET}"
}

ui_field_plain() {
  local label="$1"
  local value="$2"

  echo " ${label}${value}"
}

ui_link() {
  local link="$1"

  echo -e "${BRIGHT_WHITE}${link}${RESET}"
}

ui_menu_item() {
  local key="$1"
  local text="$2"

  echo -e " ${BRIGHT_GREEN}${key} :${RESET} ${BRIGHT_WHITE}${text}${RESET}"
}

ui_menu_nav() {
  echo
  ui_line
  ui_menu_item "0" "返回上一层"
  echo -e " ${DIM}q : 退出 AirCtl${RESET}"
}

ui_prompt() {
  echo
  echo -ne "${BRIGHT_CYAN}AirCtl > ${RESET}"
}

ui_success() {
  echo -e "${BRIGHT_GREEN}✓ $*${RESET}"
}

ui_warning() {
  echo -e "${BRIGHT_YELLOW}⚠ $*${RESET}"
}

ui_error() {
  echo -e "${BRIGHT_RED}✗ $*${RESET}"
}

ui_info() {
  echo -e "${BRIGHT_CYAN}ℹ $*${RESET}"
}

# Backward compatibility for existing scripts
line() { ui_long_line; }
logo() { ui_logo; }
success() { ui_success "$@"; }
warning() { ui_warning "$@"; }
error() { ui_error "$@"; }
info() { ui_info "$@"; }

section() {
  local icon="$1"
  local title="$2"
  local color="$3"

  ui_section "${icon} ${title}" "$color"
}

item() {
  local num="$1"
  local text="$2"

  echo -e " ${BRIGHT_GREEN}${num}.${RESET} ${BRIGHT_WHITE}${text}${RESET}"
}

title() {
  local version="$1"

  echo -e "${BOLD}${BRIGHT_WHITE}AirCtl ${BRIGHT_GREEN}v${version}${RESET}"
  echo -e "${DIM}Private Proxy Management Toolkit${RESET}"
  ui_long_line
}
