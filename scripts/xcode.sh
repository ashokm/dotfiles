#!/usr/bin/env bash
#
# xcode.sh
#
# Install Xcode Command Line Tools

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
  if test "$(uname -s)" = "Darwin"; then
    if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
      log "Install Xcode Command Line Tools"
      sudo xcode-select --install
    else
      log "Command Line Tools already installed"
    fi
  fi
}

uninstall () {
  if test "$(uname -s)" = "Darwin"; then
    if [[ -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
      log "Uninstall Xcode Command Line Tools"
      sudo rm -rf /Library/Developer/CommandLineTools
    else
      log "Command Line Tools already uninstalled"
    fi
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
