#!/usr/bin/env bash
# Zyren Tech Linux Toolkit | Version 1.0.0
set -Eeuo pipefail

VERSION="1.0.0"
BRAND="Zyren Tech"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/opt/zyren-tech"
BIN_LINK="/usr/local/bin/zyren-tech"

PURPLE=$'\033[1;35m'
CYAN=$'\033[1;36m'
YELLOW=$'\033[1;33m'
WHITE=$'\033[1;37m'
GREEN=$'\033[1;32m'
RED=$'\033[1;31m'
DIM=$'\033[2m'
RESET=$'\033[0m'
BOLD=$'\033[1m'

supports_color() { [[ -t 1 && "${TERM:-dumb}" != "dumb" ]]; }
if ! supports_color; then PURPLE='' CYAN='' YELLOW='' WHITE='' GREEN='' RED='' DIM='' RESET='' BOLD=''; fi

pause() { echo; read -r -p "  Press Enter to continue..." _ || true; }
line() { printf '%b\n' "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"; }

logo() {
  clear 2>/dev/null || true
  printf '%b\n' "${PURPLE}${BOLD}"
  cat <<'EOF'
 _____  __   __ _____  _____  _   _
|__  /  \ \ / /| ____||  ___|| \ | |
  / /    \ V / |  _|  | |_   |  \| |
 / /_     | |  | |___ |  _|  | |\  |
/____|    |_|  |_____||_|    |_| \_|
EOF
  printf '%b\n' "${RESET}"
  printf '%b\n' "${CYAN}${BOLD}                         Z Y R E N   T E C H${RESET}"
  printf '%b\n' "${YELLOW}                    LINUX TOOLKIT  •  v${VERSION}${RESET}"
  line
}

status() { printf '  %b%s%b %s\n' "$1" "$2" "$RESET" "$3"; }
need_root() {
  if [[ "$EUID" -ne 0 ]]; then
    status "$RED" "✖" "This action requires root. Run: sudo $0"
    pause
    return 1
  fi
}
run_script() {
  local file="$1"
  if [[ ! -f "$SCRIPT_DIR/$file" ]]; then
    status "$RED" "✖" "Missing script: $file"
    pause
    return
  fi
  echo
  status "$CYAN" "▶" "Launching $file"
  local rc=0
  if bash "$SCRIPT_DIR/$file"; then
    rc=0
  else
    rc=$?
  fi
  if (( rc == 0 )); then status "$GREEN" "✔" "Finished: $file"
  else status "$RED" "✖" "$file exited with status $rc"; fi
  pause
}

install_menu() {
  while true; do
    logo
    printf '%b\n' "${WHITE}${BOLD}  INSTALLATION CENTER${RESET}"
    echo
    printf '  %b[01]%b Proxmox VE Installer\n' "$PURPLE" "$RESET"
    printf '  %b[02]%b Ubuntu 22.04 PRoot Setup\n' "$PURPLE" "$RESET"
    printf '  %b[03]%b SSH Setup (Zyren Tech)\n' "$PURPLE" "$RESET"
    printf '  %b[04]%b SSH + MOTD Setup\n' "$PURPLE" "$RESET"
    printf '  %b[05]%b Zyren Tech MOTD (Premium)\n' "$PURPLE" "$RESET"
    printf '  %b[06]%b Zyren Tech MOTD (Simple)\n' "$PURPLE" "$RESET"
    printf '  %b[07]%b Fastfetch Installer\n' "$PURPLE" "$RESET"
    printf '  %b[08]%b fxTunnel Installer\n' "$PURPLE" "$RESET"
    printf '  %b[09]%b LocaltoNet Installer\n' "$PURPLE" "$RESET"
    printf '  %b[10]%b Server Detection\n' "$PURPLE" "$RESET"
    printf '  %b[11]%b Install Zyren Tech Toolkit to /opt\n' "$PURPLE" "$RESET"
    echo
    line
    printf '  %b[0]%b Back to Main Menu\n' "$YELLOW" "$RESET"
    echo
    read -r -p "  Select an option: " choice
    case "$choice" in
      1|01) run_script "proxmox-installer.sh" ;;
      2|02) run_script "root.sh" ;;
      3|03) run_script "ssh.sh" ;;
      4|04) run_script "ssh-zyren-tech.sh" ;;
      5|05) run_script "zyren-tech-motd.sh" ;;
      6|06) run_script "zyren-tech-motd-simple.sh" ;;
      7|07) run_script "fastfetch.sh" ;;
      8|08) run_script "fxtunnel-installer.sh" ;;
      9|09) run_script "localtonet.sh" ;;
      10) run_script "detect-server.sh" ;;
      11)
        if need_root; then
          mkdir -p "$INSTALL_DIR"
          cp -a "$SCRIPT_DIR/." "$INSTALL_DIR/"
          chmod +x "$INSTALL_DIR"/*.sh 2>/dev/null || true
          status "$GREEN" "✔" "Toolkit installed at $INSTALL_DIR"
          status "$CYAN" "i" "Launch with: sudo $INSTALL_DIR/zyren-tech.sh"
          pause
        fi
        ;;
      0) return ;;
      *) status "$YELLOW" "!" "Invalid option."; sleep 1 ;;
    esac
  done
}

uninstall_menu() {
  logo
  printf '%b\n' "${WHITE}${BOLD}  UNINSTALL${RESET}"
  echo
  echo "  This removes only the optional toolkit copy at:"
  printf '  %b%s%b\n\n' "$CYAN" "$INSTALL_DIR" "$RESET"
  echo "  It will NOT uninstall Proxmox VE, SSH, MOTD changes,"
  echo "  tunnel software, or packages installed by individual tools."
  echo
  read -r -p "  Remove the toolkit copy? [y/N]: " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    need_root || return
    if [[ -d "$INSTALL_DIR" ]]; then
      rm -rf -- "$INSTALL_DIR"
      if [[ -L "$BIN_LINK" ]]; then rm -f -- "$BIN_LINK"; fi
      status "$GREEN" "✔" "Toolkit files and launcher removed."
    else
      if [[ -L "$BIN_LINK" ]]; then rm -f -- "$BIN_LINK"; fi
      status "$YELLOW" "!" "No installed toolkit copy found."
    fi
  else
    status "$YELLOW" "!" "Uninstall cancelled."
  fi
  pause
}

update_menu() {
  logo
  printf '%b\n' "${WHITE}${BOLD}  UPDATE${RESET}"
  echo
  if [[ -d "$SCRIPT_DIR/.git" ]] && command -v git >/dev/null 2>&1; then
    echo "  A Git checkout was detected. Updating from its configured remote..."
    if git -C "$SCRIPT_DIR" pull --ff-only; then
      status "$GREEN" "✔" "Update completed."
    else
      status "$RED" "✖" "Update failed. Check the Git remote and local changes."
    fi
  else
    echo "  This is a ZIP/source-folder installation, not a Git checkout."
    echo "  Download the latest Zyren Tech release and replace this folder."
    status "$YELLOW" "i" "No remote URL is configured in this package."
  fi
  pause
}

while true; do
  logo
  printf '%b\n' "${WHITE}${BOLD}  MAIN MENU${RESET}"
  echo
  printf '  %b[1]%b  Install\n' "$PURPLE" "$RESET"
  printf '  %b[2]%b  Uninstall\n' "$CYAN" "$RESET"
  printf '  %b[3]%b  Update\n' "$YELLOW" "$RESET"
  echo
  line
  printf '  %b[0]%b  Exit\n' "$WHITE" "$RESET"
  echo
  read -r -p "  Select an option: " choice
  case "$choice" in
    1) install_menu ;;
    2) uninstall_menu ;;
    3) update_menu ;;
    0) echo; status "$CYAN" "◆" "Thank you for using Zyren Tech."; exit 0 ;;
    *) status "$YELLOW" "!" "Invalid option. Choose 1, 2, 3, or 0."; sleep 1 ;;
  esac
done
