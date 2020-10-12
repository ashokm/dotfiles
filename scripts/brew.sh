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
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  # Check your Homebrew system for potential problems
  if [[ -z "${CI_ENABLED}" ]]; then
    echo "[INFO] Check your Homebrew system for potential problems ..."
    brew cleanup
    brew doctor
  else
    echo "[skip ci] Check your Homebrew system for potential problems ..."
  fi

  # Uninstall unwanted pre-installed packages on CI build agents
  # See links below for installed software:
  # https://github.com/microsoft/azure-pipelines-image-generation/tree/master/images
  # https://github.com/actions/virtual-environments/tree/main/images
  if [[ "${CI_ENABLED}" ]]; then
    echo "[INFO] Uninstall unwanted pre-installed packages on CI build agents ..."
    BREW_PACKAGES=('aws-sam-cli' 'session-manager-plugin')
    for package in "${BREW_PACKAGES[@]}"; do
      brew uninstall "$package" --force
    done
    FILES="/usr/local/bin/aws
    /usr/local/aws-cli/aws
    /usr/local/bin/aws_completer
    /usr/local/aws-cli/aws_completer"
    for file in $FILES; do
      if [ -f "$file" ]; then
        echo "[INFO] Removing $file ..."
        sudo rm "$file"
      fi
    done
  fi

  # Run Homebrew through the Brewfile
  echo "[INFO] Install packages listed in Brewfile ..."
  brew bundle --file="Brewfile"
  echo "[INFO] Uninstall packages not listed in Brewfile ..."
  brew bundle cleanup --file="Brewfile" --force && brew cleanup
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
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
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
