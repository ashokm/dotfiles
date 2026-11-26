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
  if is_noninteractive; then
    log "Skipping Xcode Command Line Tools install in non-interactive mode"
    return 0
  fi

  if [[ ! -d "$('xcode-select' -print-path 2> /dev/null)" ]]; then
    log "Install Xcode Command Line Tools"
    sudo xcode-select --install
  else
    log "Xcode Command Line Tools already installed"
  fi
}

uninstall() {
  if is_noninteractive; then
    log "Skipping Xcode Command Line Tools uninstall in non-interactive mode"
    return 0
  fi

  if [[ -d "$('xcode-select' -print-path 2> /dev/null)" ]]; then
    log "Uninstall Xcode Command Line Tools"
    sudo rm -rf /Library/Developer/CommandLineTools
  else
    log "Xcode Command Line Tools already uninstalled"
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
