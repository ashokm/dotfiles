#!/usr/bin/env bash
#
# brew.sh
#
# Install Homebrew

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
    log "Install Homebrew"
    if test ! "$(command -v brew)"; then
      if test "$(uname -s)" = "Darwin"; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && brew cleanup
      fi
    fi

    # Check your Homebrew system for potential problems
    if [[ -z "${CI_ENABLED}" ]]; then
      echo "[INFO] Check your Homebrew system for potential problems ..."
      brew doctor
    else
      echo "[ci-skip] Check your Homebrew system for potential problems ..."
    fi

    # Run Homebrew through the Brewfile
    echo "[INFO] Install packages listed in the Brewfile ..."
    brew bundle --file="Brewfile"
    echo "[INFO] Uninstall packages not listed in the Brewfile ..."
    brew bundle cleanup --file="Brewfile" --force && brew cleanup
}

uninstall () {
  if [[ -z "${CI_ENABLED}" ]]; then
    log "Uninstall Homebrew"
    # Check for Homebrew
    if test "$(command -v brew)"; then
      echo "[INFO] Uninstall packages installed using Brew cask ..."
      brew cask uninstall --force "$(brew cask list)" && brew cask cleanup
      echo "[INFO] Uninstall packages installed using Brew ..."
      brew remove --force "$(brew list)" && brew cleanup
      if test "$(uname -s)" = "Darwin"; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
      fi
    fi
  else
    log "[ci-skip] Uninstall Homebrew"
  fi
}

CI_ENABLED=${CI:-}

case "$1" in
  "--install" )
  install ;;
  "--uninstall" )
  uninstall ;;
  * )
  usage ;;
esac
