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
  if [ ! -L ~/.config/starship.toml ]; then
    log "Install Starship Configuration"
    if [ ! -d ~/.config ]; then
      log "Creating ~/.config"
      mkdir ~/.config
      chmod 700 ~/.config
    fi
    ln -sf "$DOTFILES_DIR/config/starship/starship.toml" ~/.config/starship.toml
  fi
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
