#!/usr/bin/env bash
#
# rvm.sh
#
# Install RVM

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install () {
    log "Install RVM"
    if test ! "$(command -v rvm)"; then
      curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles
    fi
}

uninstall () {
    log "Uninstall RVM"
    if test "$(command -v rvm)"; then
      rvm implode
      echo "[INFO] Removing rm -rf ~/.rvm" && rm -rf ~/.rvm
    fi
}

case "$1" in
  "--install" )
  install ;;
  "--uninstall" )
  uninstall ;;
  * )
  usage ;;
esac
