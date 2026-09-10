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
  log "Install GitHub Copilot configuration"

  mkdir -p "$GITHUB_COPILOT_HOME"
  mkdir -p "$INTELLIJ_COPILOT_DIR"

  # JetBrains: global GitHub Copilot instructions.
  ln -sfn \
    "$DOTFILES_DIR/config/github-copilot/global-copilot-instructions.md" \
    "$INTELLIJ_COPILOT_DIR/global-copilot-instructions.md"

  # GitHub Copilot CLI: global instructions.
  ln -sfn \
    "$DOTFILES_DIR/config/github-copilot/global-copilot-instructions.md" \
    "$GITHUB_COPILOT_HOME/copilot-instructions.md"

  # GitHub Copilot CLI: global agent instructions.
  ln -sfn \
    "$DOTFILES_DIR/config/github-copilot/global-agents.md" \
    "$GITHUB_COPILOT_HOME/AGENTS.md"

  # JetBrains: global Git commit instructions.
  ln -sfn \
    "$DOTFILES_DIR/config/github-copilot/intellij/global-git-commit-instructions.md" \
    "$INTELLIJ_COPILOT_DIR/global-git-commit-instructions.md"
}

uninstall() {
  log "Uninstall GitHub Copilot configuration"

  rm -f \
    "$INTELLIJ_COPILOT_DIR/global-copilot-instructions.md" \
    "$INTELLIJ_COPILOT_DIR/global-git-commit-instructions.md" \
    "$GITHUB_COPILOT_HOME/copilot-instructions.md" \
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
