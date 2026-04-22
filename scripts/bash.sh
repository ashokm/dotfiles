#!/bin/bash
#
# bash.sh
#
# Change the login shell to the Homebrew-managed bash (bash 5.x).
#
# The macOS system bash (/bin/bash) is frozen at 3.2 due to GPLv3 licensing.
# bash-completion@2 and many completion scripts (including 'source <(...)') require bash 4.2+.
# Using the Homebrew bash ensures full compatibility with modern completion mechanisms.

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

homebrew_bash() {
  # Intel processor
  if [ -r /usr/local/bin/brew ]; then
    echo "/usr/local/bin/bash"
  # Apple Silicon
  elif [ -r /opt/homebrew/bin/brew ]; then
    echo "/opt/homebrew/bin/bash"
  else
    echo ""
  fi
}

install() {
  log "Set login shell to Homebrew bash"

  BREW_BASH="$(homebrew_bash)"

  if [ -z "$BREW_BASH" ]; then
    echo "[ERROR] Homebrew bash not found. Run brew.sh --install first."
    exit 1
  fi

  if [ ! -f "$BREW_BASH" ]; then
    echo "[ERROR] $BREW_BASH does not exist. Ensure 'brew install bash' has been run."
    exit 1
  fi

  if [ -n "${CI:-}" ]; then
    echo "[INFO] CI environment detected — skipping login shell change (chsh requires local credentials)"
    return 0
  fi

  # Add Homebrew bash to /etc/shells if not already present
  if ! grep -qF "$BREW_BASH" /etc/shells; then
    echo "[INFO] Adding $BREW_BASH to /etc/shells ..."
    echo "$BREW_BASH" | sudo tee -a /etc/shells > /dev/null
  else
    echo "[INFO] $BREW_BASH is already listed in /etc/shells"
  fi

  # Change the login shell
  if [ "$SHELL" = "$BREW_BASH" ]; then
    echo "[INFO] Login shell is already set to $BREW_BASH"
  else
    echo "[INFO] Changing login shell from $SHELL to $BREW_BASH ..."
    chsh -s "$BREW_BASH"
    echo "[INFO] Done. Open a new terminal window for the change to take effect."
  fi
}

uninstall() {
  log "Restore login shell to system bash (/bin/bash)"

  if [ -n "${CI:-}" ]; then
    echo "[INFO] CI environment detected — skipping login shell change"
    return 0
  fi

  if [ "$SHELL" = "/bin/bash" ]; then
    echo "[INFO] Login shell is already /bin/bash"
  else
    echo "[INFO] Changing login shell back to /bin/bash ..."
    chsh -s /bin/bash
  fi

  BREW_BASH="$(homebrew_bash)"
  if [ -n "$BREW_BASH" ] && grep -qF "$BREW_BASH" /etc/shells; then
    echo "[INFO] Removing $BREW_BASH from /etc/shells ..."
    sudo sed -i '' "\|$BREW_BASH|d" /etc/shells
  fi
}

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
