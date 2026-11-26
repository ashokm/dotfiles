#!/bin/bash
#
# brew.sh
#
# Install Homebrew

set -o errexit -o nounset -o pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  echo "Usage: $0 [--install | --uninstall | --update | --clean]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install() {
  log "Homebrew packages"

  if ! command -v brew > /dev/null 2>&1; then
    log "Install Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Add Homebrew to PATH for the current script.
  # Intel processor
  if [ -r /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  # Apple silicon
  elif [ -r /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  brew analytics off

  # Set temporary ulimit to prevent 'Error: Too many open files' when installing long-chained formula
  ulimit -n 2048

  # Run Homebrew through the Brewfile
  echo "[INFO] Uninstall packages not listed in Brewfile ..."
  brew bundle cleanup --file="$DOTFILES_DIR/Brewfile" --force
  echo "[INFO] Install packages listed in Brewfile ..."
  # Hide the per-package "Using ..." lines; Brew reports its completion summary.
  brew bundle --file="$DOTFILES_DIR/Brewfile" | awk '!/^Using /'

  clean
  echo "[INFO] Homebrew packages are up to date."
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

  fi
}

update() {
  if test "$(command -v brew)"; then
    log "Updating Homebrew"
    # Keep the no-change case concise while preserving useful update output and errors.
    local output
    local status
    if output="$(brew update 2>&1)"; then
      output="$(printf '%s\n' "$output" | sed \
        -e '/^==> Updating Homebrew\.\.\.$/d' \
        -e '/^Already[- ]up-to-date\.$/d' \
        -e '/^[[:space:]]*$/d')"
      if [[ -z "$output" ]]; then
        echo "[INFO] Homebrew is up to date."
      else
        printf '%s\n' "$output"
      fi
    else
      status=$?
      printf '%s\n' "$output" >&2
      return "$status"
    fi

    log "Updating installed Homebrew packages"
    brew upgrade
    brew upgrade --cask
  fi
}

clean() {
  if test "$(command -v brew)"; then
    log "Running Homebrew maintenance"
    # Remove formulae no longer needed as dependencies, then clear stale downloads.
    brew autoremove

    brew cleanup

    echo "[INFO] Checking your Homebrew system for potential problems"
    brew doctor
  fi
}

case "${1:-}" in
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
