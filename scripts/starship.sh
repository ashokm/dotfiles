#!/bin/bash
#
# starship.sh
#
# Setup Starship Configuration

set -o errexit -o nounset -o pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install() {
  log "Starship configuration"
  local destination="$HOME/.config/starship.toml"
  local source="$DOTFILES_DIR/config/starship/starship.toml"

  # Keep a correct link intact and protect any existing user-managed file.
  if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$source" ]; then
    echo "[INFO] Starship configuration is up to date."
    return
  fi

  if [ -e "$destination" ] && [ ! -L "$destination" ]; then
    echo "[ERROR] Cannot link $source: $destination exists and is not a symlink." >&2
    return 1
  fi

  if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"
    chmod 700 "$HOME/.config"
  fi

  ln -sfn "$source" "$destination"
  echo "[INFO] Starship configuration is installed."
}

uninstall() {
  log "Uninstall Starship Configuration"
  if [ -L ~/.config/starship.toml ]; then
    rm -f ~/.config/starship.toml
  fi
}

case "${1:-}" in
"--install")
  install
  ;;
"--uninstall")
  uninstall
  ;;
*)
  usage
  ;;
esac
