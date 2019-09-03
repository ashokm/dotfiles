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
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
        echo "Installing dependencies for Debian or Ubuntu ..."
        sudo apt-get install build-essential curl file git
        echo "Add Homebrew to your PATH and to your bash shell profile script"
        test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
        test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.bash_profile
        echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.profile
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
