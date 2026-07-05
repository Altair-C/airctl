#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/opt/airport"

while true; do
  clear
  echo "======================================"
  echo " Airport Deploy - Hysteria2 Manager"
  echo "======================================"
  echo "1) 服务状态"
  echo "2) 重启服务"
  echo "3) 查看实时日志"
  echo "4) 新增用户"
  echo "5) 删除用户"
  echo "6) 用户列表"
  echo "7) 生成用户链接"
  echo "8) 显示用户二维码"
  echo "9) 查看服务端口"
  echo "0) 退出"
  echo "======================================"
  read -rp "请选择: " choice

  case "$choice" in
    1) bash "${BASE_DIR}/scripts/service-status.sh" ;;
    2) bash "${BASE_DIR}/scripts/service-restart.sh" ;;
    3) bash "${BASE_DIR}/scripts/service-logs.sh" ;;
    4) bash "${BASE_DIR}/scripts/user-add.sh" ;;
    5) bash "${BASE_DIR}/scripts/user-del.sh" ;;
    6) bash "${BASE_DIR}/scripts/user-list.sh" ;;
    7) bash "${BASE_DIR}/scripts/user-link.sh" ;;
    8) bash "${BASE_DIR}/scripts/user-qr.sh" ;;
    9) bash "${BASE_DIR}/scripts/service-port.sh" ;;
    0) exit 0 ;;
    *) echo "无效选择" ;;
  esac

  echo
  read -rp "按 Enter 返回菜单..."
done
