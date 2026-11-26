#!/bin/bash
#
# github-copilot.sh
#
# Manage GitHub Copilot configuration

set -o errexit -o nounset -o pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# GitHub Copilot CLI configuration directory (current upstream location).
GITHUB_COPILOT_HOME="$HOME/.copilot"

# GitHub Copilot custom instructions for JetBrains IDEs.
INTELLIJ_COPILOT_DIR="$HOME/.config/github-copilot/intellij"

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^\.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install() {
  log "GitHub Copilot configuration"

  check_configuration \
    "$DOTFILES_DIR/config/github-copilot/global-copilot-instructions.md" \
    "$INTELLIJ_COPILOT_DIR/global-copilot-instructions.md" || return
  check_configuration \
    "$DOTFILES_DIR/config/github-copilot/global-copilot-instructions.md" \
    "$GITHUB_COPILOT_HOME/copilot-instructions.md" || return
  check_configuration \
    "$DOTFILES_DIR/config/github-copilot/global-agents.md" \
    "$GITHUB_COPILOT_HOME/AGENTS.md" || return
  check_configuration \
    "$DOTFILES_DIR/config/github-copilot/intellij/global-git-commit-instructions.md" \
    "$INTELLIJ_COPILOT_DIR/global-git-commit-instructions.md" || return

  mkdir -p "$GITHUB_COPILOT_HOME"
  mkdir -p "$INTELLIJ_COPILOT_DIR"

  link_configuration \
    "$DOTFILES_DIR/config/github-copilot/global-copilot-instructions.md" \
    "$INTELLIJ_COPILOT_DIR/global-copilot-instructions.md" || return
  link_configuration \
    "$DOTFILES_DIR/config/github-copilot/global-copilot-instructions.md" \
    "$GITHUB_COPILOT_HOME/copilot-instructions.md" || return
  link_configuration \
    "$DOTFILES_DIR/config/github-copilot/global-agents.md" \
    "$GITHUB_COPILOT_HOME/AGENTS.md" || return
  link_configuration \
    "$DOTFILES_DIR/config/github-copilot/intellij/global-git-commit-instructions.md" \
    "$INTELLIJ_COPILOT_DIR/global-git-commit-instructions.md" || return

  echo "[INFO] GitHub Copilot configuration is ready."
}

check_configuration() {
  local source="$1"
  local destination="$2"

  if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$source" ]; then
    return 0
  fi

  if [ -e "$destination" ] || [ -L "$destination" ]; then
    echo "[ERROR] Cannot link $source: $destination already exists and is not managed by dotfiles." >&2
    return 1
  fi
}

link_configuration() {
  local source="$1"
  local destination="$2"

  check_configuration "$source" "$destination" || return

  if [ ! -L "$destination" ]; then
    ln -s "$source" "$destination"
  fi
}

remove_configuration() {
  local source="$1"
  local destination="$2"

  if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$source" ]; then
    rm "$destination"
  fi
}

uninstall() {
  log "Uninstall GitHub Copilot configuration"

  remove_configuration \
    "$DOTFILES_DIR/config/github-copilot/global-copilot-instructions.md" \
    "$INTELLIJ_COPILOT_DIR/global-copilot-instructions.md"
  remove_configuration \
    "$DOTFILES_DIR/config/github-copilot/intellij/global-git-commit-instructions.md" \
    "$INTELLIJ_COPILOT_DIR/global-git-commit-instructions.md"
  remove_configuration \
    "$DOTFILES_DIR/config/github-copilot/global-copilot-instructions.md" \
    "$GITHUB_COPILOT_HOME/copilot-instructions.md"
  remove_configuration \
    "$DOTFILES_DIR/config/github-copilot/global-agents.md" \
    "$GITHUB_COPILOT_HOME/AGENTS.md"

  # Remove directories only when empty; ignore "directory not empty" failures.
  rmdir "$GITHUB_COPILOT_HOME" 2> /dev/null || true
  rmdir "$INTELLIJ_COPILOT_DIR" 2> /dev/null || true
}

case "${1:-}" in
--install)
  install
  ;;
--uninstall)
  uninstall
  ;;
*)
  usage
  exit 1
  ;;
esac
