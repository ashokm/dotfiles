#!/bin/bash
#
# brew.sh
#
# Install Homebrew

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0 [--install | --uninstall | --update | --clean]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install() {
  if test ! "$(command -v brew)"; then
  log "Install Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log "Homebrew already installed"
  fi

  echo "[INFO] Add Homebrew to PATH ..."
  # Intel Macs
  if [ -r /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  # M1 Macs
  elif [ -r /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
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

  clean
}

uninstall() {
  if test "$(command -v brew)"; then
    log "Uninstall Homebrew"
    echo "[INFO] Uninstall packages installed using Brew ..."
    if test "$(brew list --formula)"; then
      # shellcheck disable=SC2046
      brew uninstall --force --ignore-dependencies $(brew list --formula)
    fi
    echo "[INFO] Uninstall packages installed using Brew cask ..."
    if test "$(brew list --cask)"; then
      # shellcheck disable=SC2046
      brew uninstall --cask --force --ignore-dependencies $(brew list --cask)
    fi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

    DIRS="/usr/local/.com.apple.installer.keep
          /usr/local/Frameworks/
          /usr/local/Homebrew/
          /usr/local/aws-cli/
          /usr/local/bin/
          /usr/local/etc/
          /usr/local/include/
          /usr/local/lib/
          /usr/local/microsoft/
          /usr/local/miniconda/
          /usr/local/opt/
          /usr/local/sbin/
          /usr/local/share/
          /usr/local/var/
          /opt/homebrew/Frameworks/
          /opt/homebrew/bin/
          /opt/homebrew/etc/
          /opt/homebrew/include/
          /opt/homebrew/lib/
          /opt/homebrew/opt/
          /opt/homebrew/sbin/
          /opt/homebrew/share/
          /opt/homebrew/var/"

    for dir in $DIRS; do
      if [ -d "$dir" ]; then
        echo "[INFO] Removing $dir ..."
        sudo rm -rf "$dir"
      fi
    done

  else
    log "Homebrew already uninstalled"
  fi
}

update() {
  if test "$(command -v brew)"; then
    log "Updating Homebrew"
    brew update

    log "Updating installed Homebrew packages"
    brew upgrade
    brew upgrade --cask

    clean
  fi
}

clean() {
  if test "$(command -v brew)"; then
    log "Running Homebrew maintenance"
    echo "[INFO] Uninstall formulae that were only installed as a dependency of another formula and are now no longer needed"
    brew autoremove

    echo "[INFO] Remove stale lock files and outdated downloads for all formulae and casks"
    brew cleanup

    echo "[INFO] Checking your Homebrew system for potential problems"
    brew doctor
  fi
}

case "$1" in
"--install")
  install
  ;;
"--uninstall")
  uninstall
  ;;
"--update")
  update
  ;;
"--clean")
  clean
  ;;
*)
  usage
  ;;
esac
