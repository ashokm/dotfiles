#!/bin/bash
#
# starship.sh
#
# Setup Starship Configuration

set -o errexit -o nounset -o pipefail

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
    ln -sf "$(pwd)"/config/starship/starship.toml ~/.config/starship.toml
  fi
}

uninstall() {
  log "Uninstall Starship Configuration"
  rm -f ~/.config/starship.toml
}

case "$1" in
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
