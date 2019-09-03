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
      # Install the correct homebrew for each OS type
      if test "$(uname -s)" = "Darwin"
      then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      elif test "$(uname -s)" = "Linux"
      then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      fi
    fi

    # Check your system for potential problems
    echo "[INFO] Check your system for potential problems ..."
    brew doctor

    # Run Homebrew through the Brewfile
    echo "[INFO] Installing development dependencies from Brewfile.$(uname -s) ..."
    brew bundle --file="Brewfile.$(uname -s)"
    echo "[INFO] Uninstalling development dependencies not in Brewfile.$(uname -s) ..."
    brew bundle cleanup --file="Brewfile.$(uname -s)" --force
}

uninstall () {
    log "Uninstall Homebrew"
    # Check for Homebrew
    if test "$(which brew)"
    then
      # Install the correct homebrew for each OS type
      if test "$(uname -s)" = "Darwin"
      then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
      elif test "$(uname -s)" = "Linux"
      then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/uninstall)"
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
