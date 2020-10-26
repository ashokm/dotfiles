#!/usr/bin/env bash
#
# brew.sh
#
# Install Homebrew

# Fix "brew: command not found" when running bootstrap.sh on Linux

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
  log "Install Homebrew"
  if test ! "$(command -v brew)"; then
    HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
    /bin/bash -c "$(curl -fsSL ${HOMEBREW_INSTALL_URL})"
  fi

  echo "[INFO] Disable Homebrew analytics ..."
  brew analytics off

  # Run Homebrew through the Brewfile
  echo "[INFO] Uninstall packages not listed in Brewfile ..."
  brew bundle cleanup --file="Brewfile" --force
  echo "[INFO] Install packages listed in Brewfile ..."
  brew bundle --file="Brewfile"

  # Check your Homebrew system for potential problems
  echo "[INFO] Check your Homebrew system for potential problems ..."
  brew cleanup
  brew doctor
}

uninstall() {
  if [[ -z "${CI_ENABLED}" ]]; then
    log "Uninstall Homebrew"
    # Check for Homebrew
    if test "$(command -v brew)"; then
      if test "$(uname -s)" = "Darwin"; then
        echo "[INFO] Uninstall packages installed using Brew cask ..."
        brew cask uninstall --force "$(brew list --cask)" && brew cask cleanup
      fi
      echo "[INFO] Uninstall packages installed using Brew ..."
      brew remove --force "$(brew list)" && brew cleanup
      HOMEBREW_UNINSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh"
      /bin/bash -c "$(curl -fsSL ${HOMEBREW_UNINSTALL_URL})"
    fi
  else
    log "[skip ci] Uninstall Homebrew"
  fi
}

CI_ENABLED=${CI:-}

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
