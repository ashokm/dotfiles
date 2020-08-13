#!/usr/bin/env bash
#
# linux.sh
#
# Install Linux software (that is not available via Homebrew)

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

# shellcheck disable=SC2032
install() {
  # Install Linux software
  log "Install Linux software"
  # shellcheck disable=SC2033
  sudo apt-get install build-essential gnupg2 -y
}

uninstall() {
  # Uninstall Linux software
  log "Uninstall Linux software"
  sudo apt-get remove build-essential gnupg2 -y && sudo apt-get autoremove -y
}

if test "$(uname -s)" = "Linux"; then
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
fi
