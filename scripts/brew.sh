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
      if test "$(uname)" = "Darwin"
      then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      elif test "$(substr "$(uname -s)" 1 5)" = "Linux"
      then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
      fi
    fi

    # Check your system for potential problems
    echo "Check your system for potential problems ..."
    brew doctor

    # Run Homebrew through the Brewfile
    echo "Installing development dependencies from Brewfile ..."
    brew bundle --file="Brewfile"
    echo "Uninstalling development dependencies not in Brewfile ..."
    brew bundle cleanup --file="Brewfile" --force
}

uninstall () {
    log "Uninstall Homebrew"
    # Check for Homebrew
    if test "$(which brew)"
    then
      # Install the correct homebrew for each OS type
      if test "$(uname)" = "Darwin"
      then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
      elif test "$(substr "$(uname -s)" 1 5)" = "Linux"
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
