#!/usr/bin/env bash
set -Eeuo pipefail

BRAND="Zyren Tech"
INSTALL_DIR="/opt/zyren-tech"
BIN_LINK="/usr/local/bin/zyren-tech"
REPO_URL=""

for arg in "$@"; do
  case "$arg" in
    --repo=*) REPO_URL="${arg#*=}" ;;
    -h|--help)
      echo "Usage: sudo bash install.sh [--repo=https://github.com/USER/REPO.git]"
      exit 0
      ;;
    *) echo "Unknown argument: $arg" >&2; exit 2 ;;
  esac
done

if [[ "${EUID}" -ne 0 ]]; then
  echo "Please run as root: sudo bash install.sh" >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/zyren-tech.sh" ]]; then
  SOURCE_DIR="$SCRIPT_DIR"
elif [[ -n "$REPO_URL" ]]; then
  command -v git >/dev/null 2>&1 || { apt-get update && apt-get install -y git; }
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' EXIT
  git clone --depth 1 "$REPO_URL" "$TMP_DIR/repo"
  SOURCE_DIR="$TMP_DIR/repo"
else
  echo "Cannot find zyren-tech.sh beside install.sh." >&2
  echo "Run from the cloned repository, or pass --repo=URL." >&2
  exit 1
fi

[[ -f "$SOURCE_DIR/zyren-tech.sh" ]] || { echo "Main menu not found in source." >&2; exit 1; }
mkdir -p "$INSTALL_DIR"
# Preserve .git when installing a cloned repository so the Update menu works.
cp -a "$SOURCE_DIR/." "$INSTALL_DIR/"
chmod 755 "$INSTALL_DIR"/*.sh
ln -sfn "$INSTALL_DIR/zyren-tech.sh" "$BIN_LINK"
echo "${BRAND} installed successfully."
echo "Launch with: sudo zyren-tech"
if [[ -t 0 && -t 1 ]]; then
  exec "$BIN_LINK"
fi
