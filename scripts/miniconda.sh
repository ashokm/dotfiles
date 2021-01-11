#!/usr/bin/env bash
#
# miniconda.sh
#
# Install Miniconda

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
  if test ! "$(command -v conda)"; then
    log "Install Miniconda"
    MINICONDA_MACOSX_INSTALL_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
    MINICONDA_LINUX_INSTALL_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    echo "Downloading Miniconda ..."
    if test "$(uname -s)" = "Darwin"; then
      curl -fsSL ${MINICONDA_MACOSX_INSTALL_URL} -o /tmp/Miniconda3-latest-MacOSX-x86_64.sh
    elif test "$(uname -s)" = "Linux"; then
      curl -fsSL ${MINICONDA_LINUX_INSTALL_URL} -o /tmp/Miniconda3-latest-MacOSX-x86_64.sh
    fi
    echo "Installing Miniconda ..."
    chmod +x /tmp/Miniconda3-latest-MacOSX-x86_64.sh
    /tmp/Miniconda3-latest-MacOSX-x86_64.sh -b && rm -rf /tmp/Miniconda3-latest-MacOSX-x86_64.sh
  else
    log "Miniconda already installed"
  fi
}

uninstall() {
  if test "$(command -v conda)"; then
    log "Uninstall Miniconda"
    rm -rf "$HOME/miniconda3"
    rm -rf "$HOME/.conda"
  else
    log "Miniconda already uninstalled"
  fi
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
