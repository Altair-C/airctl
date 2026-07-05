#!/usr/bin/env bash
set -euo pipefail

source /opt/airctl/lib/users.sh
source /opt/airctl/lib/config.sh
source /opt/airctl/lib/ui.sh
source /opt/airctl/lib/input.sh

ensure_users_db
migrate_users_db
ensure_airctl_config

server_ip="$(curl -fsS https://api.ipify.org || hostname -I | awk '{print $1}')"
port="$(config_get_port)"
sni="$(config_get_sni)"

show_user_detail() {
  local username="$1"
  local password remark enabled created_at token status_icon status_text link

  password="$(user_password "$username")"
  remark="$(user_remark "$username")"
  enabled="$(user_enabled "$username")"
  created_at="$(user_created_at "$username")"
  token="$(user_token "$username")"
  if [ -z "$token" ]; then
    token="$(openssl rand -hex 24)"
    user_set_token "$username" "$token"
  fi

  if [[ "$created_at" =~ Z$ ]]; then
    created_at="$(date -d "$created_at" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "$created_at")"
  fi

  if [ "$enabled" = "true" ]; then
    status_icon="🟢"
    status_text="Enabled"
  else
    status_icon="🔴"
    status_text="Disabled"
  fi

  link="hy2://${username}:${password}@${server_ip}:${port}/?sni=${sni}&insecure=1#${username}"

  while true; do
    clear
    ui_page_title "用户详情"

    ui_section "👤 用户信息" "$BRIGHT_BLUE"
    ui_field "用户名" "$username"
    ui_field "备注" "${remark:-无}"
    ui_field "状态" "$status_icon $status_text"
    ui_field "创建时间" "${created_at:-unknown}"

    ui_section "🌐 连接信息" "$BRIGHT_CYAN"
    ui_field "服务器" "$server_ip"
    ui_field "端口" "${port}/udp"
    ui_field "SNI" "$sni"
    ui_field "协议" "Hysteria2"

    ui_section "🔐 认证信息" "$BRIGHT_YELLOW"
    ui_field "密码" "$password"
    ui_field "订阅Token" "$token"

    ui_section "🔗 HY2 链接" "$BRIGHT_GREEN"
    ui_link "$link"

    ui_section "⚙️ 操作" "$BRIGHT_MAGENTA"
    ui_menu_item "1" "修改密码"
    ui_menu_item "2" "显示二维码"
    ui_menu_item "3" "导出配置"
    ui_nav

    ui_prompt
    action="$(ui_read_key)"
    echo

    case "$action" in
      1) bash /opt/airctl/scripts/user-passwd.sh "$username"; ui_pause ;;
      2) bash /opt/airctl/scripts/user-qr.sh "$username"; ui_pause ;;
      3) bash /opt/airctl/scripts/user-link.sh "$username"; ui_pause ;;
      0) return ;;
      q|Q) exit 0 ;;
      *) ui_warning "无效选择"; ui_pause ;;
    esac
  done
}

while true; do
  clear
  ui_page_title "用户列表"

  mapfile -t users < <(user_list_names)

  if [ "${#users[@]}" -eq 0 ]; then
    ui_warning "暂无用户"
    echo
    read -rp "按 Enter 返回..."
    exit 0
  fi

  index=1
  for username in "${users[@]}"; do
    remark="$(user_remark "$username")"
    if [ -n "$remark" ]; then
      echo -e " ${BRIGHT_GREEN}${index} :${RESET} ${BRIGHT_WHITE}${username}${RESET} ${DIM}(${remark})${RESET}"
    else
      echo -e " ${BRIGHT_GREEN}${index} :${RESET} ${BRIGHT_WHITE}${username}${RESET}"
    fi
    index=$((index + 1))
  done

  ui_nav
  ui_prompt
  choice="$(ui_read_key)"
  echo

  case "$choice" in
    0) exit 0 ;;
    q|Q) exit 0 ;;
  esac

  if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    ui_warning "请输入数字"
    ui_pause
    continue
  fi

  if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#users[@]}" ]; then
    ui_warning "无效选择"
    ui_pause
    continue
  fi

  selected="${users[$((choice - 1))]}"
  show_user_detail "$selected"
done
