#!/bin/bash
#
# copilot.sh
#
# Manage GitHub Copilot configuration

set -o errexit -o nounset -o pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

COPILOT_HOME="$HOME/.copilot"
INTELLIJ_COPILOT_DIR="$HOME/.config/github-copilot/intellij"

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install() {
  log "Install GitHub Copilot configuration"

  mkdir -p "$COPILOT_HOME"
  mkdir -p "$INTELLIJ_COPILOT_DIR"

  ln -sfn \
    "$DOTFILES_DIR/config/copilot/global-copilot-instructions.md" \
    "$COPILOT_HOME/copilot-instructions.md"

  ln -sfn \
    "$DOTFILES_DIR/config/copilot/global-agents.md" \
    "$COPILOT_HOME/AGENTS.md"

  ln -sfn \
    "$DOTFILES_DIR/config/copilot/intellij/global-git-commit-instructions.md" \
    "$INTELLIJ_COPILOT_DIR/global-git-commit-instructions.md"
}

uninstall() {
  log "Uninstall GitHub Copilot configuration"

  rm -f \
    "$COPILOT_HOME/copilot-instructions.md" \
    "$COPILOT_HOME/AGENTS.md" \
    "$INTELLIJ_COPILOT_DIR/global-git-commit-instructions.md"

  rmdir "$COPILOT_HOME" 2> /dev/null || true
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
