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
  if test ! "$(command -v brew)"; then
  log "Install Homebrew"
    HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
    /bin/bash -c "$(curl -fsSL ${HOMEBREW_INSTALL_URL})"
  else
    log "Homebrew already installed"
  fi

  echo "[INFO] Disable Homebrew analytics ..."
  brew analytics off

  # Set temporary ulimit to prevent 'Error: Too many open files' when installing long-chained formula
  ulimit -n 2048

  # Run Homebrew through the Brewfile
  echo "[INFO] Uninstall packages not listed in Brewfile ..."
  brew bundle cleanup --file="Brewfile" --force
  echo "[INFO] Install packages listed in Brewfile ..."
  brew bundle --file="Brewfile"

  # Check your Homebrew system for potential problems
  echo "[INFO] Check your Homebrew system for potential problems ..."
  brew cleanup
  brew doctor || true
}

uninstall() {
  if test "$(command -v brew)"; then
    log "Uninstall Homebrew"
    if test "$(uname -s)" = "Darwin"; then
      if [[ "${CI_ENABLED}" ]]; then
        # Workaround: Uninstall unwanted pre-installed packages on CI build agent
        log "Uninstall unwanted pre-installed packages on CI build agent"
        BREW_PACKAGES=('openssl@1.0.2t' 'python@2.7.17')
        for package in "${BREW_PACKAGES[@]}"; do
          brew uninstall --force "$package"
        done
      fi
      echo "[INFO] Uninstall packages installed using Brew cask ..."
      brew uninstall --cask --force "$(brew list --cask)" && brew cleanup
    fi
    echo "[INFO] Uninstall packages installed using Brew ..."
    brew uninstall --force "$(brew list --formula)" && brew cleanup

    HOMEBREW_UNINSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh"
    /bin/bash -c "$(curl -fsSL ${HOMEBREW_UNINSTALL_URL})"
  else
    log "Homebrew already uninstalled"
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
