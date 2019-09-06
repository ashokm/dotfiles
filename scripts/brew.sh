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
    # Check for Homebrew
    if test ! "$(which brew)"
    then
      if test "$(uname -s)" = "Darwin"
      then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      fi
    fi

    # Check your system for potential problems
    echo "[INFO] Check your system for potential problems ..."
    brew doctor

    # Run Homebrew through the Brewfile
    echo "[INFO] Installing packages from Brewfile ..."
    brew bundle --file="Brewfile"
    echo "[INFO] Uninstalling packages not in Brewfile ..."
    brew bundle cleanup --file="Brewfile" --force && brew cleanup
}

uninstall () {
    log "Uninstall Homebrew"
    # Check for Homebrew
    if test "$(which brew)"
    then
      echo "[INFO] Uninstalling packages installed using Brew ..."
      brew remove --force "$(brew list)" && brew cleanup
      echo "[INFO] Uninstalling packages installed using Brew cask ..."
      brew cask uninstall --force "$(brew cask list)" && brew cask cleanup
      # Uninstall the correct homebrew for each OS type
      if test "$(uname -s)" = "Darwin"
      then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
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
