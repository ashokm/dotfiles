#!/bin/bash
#
# xcode.sh
#
# Install Xcode Command Line Tools

set -o errexit -o nounset -o pipefail

is_noninteractive() {
  [ -n "${CI:-}" ] || [ -n "${NONINTERACTIVE:-}" ]
}

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install() {
  log "Xcode Command Line Tools"

  if is_noninteractive; then
    echo "[INFO] Installation skipped in non-interactive mode."
    return 0
  fi

  if [[ ! -d "$('xcode-select' -print-path 2> /dev/null)" ]]; then
    sudo xcode-select --install
    echo "[INFO] Xcode Command Line Tools installation requested."
  else
    echo "[INFO] Xcode Command Line Tools are ready."
  fi
}

uninstall() {
  log "Xcode Command Line Tools"

  if is_noninteractive; then
    return 0
  fi

  if [[ -d "$('xcode-select' -print-path 2> /dev/null)" ]]; then
    sudo rm -rf /Library/Developer/CommandLineTools
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
