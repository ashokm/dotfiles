#!/bin/bash
#
# copilot.sh
#
# Setup shared Copilot and IntelliJ configuration

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
  log "Install Copilot and IntelliJ configuration"

  mkdir -p ~/.config/github-copilot/intellij

  ln -sf "$(pwd)"/config/copilot/intellij/global-git-commit-instructions.md \
    ~/.config/github-copilot/intellij/global-git-commit-instructions.md
  ln -sf "$(pwd)"/config/copilot/intellij/global-agents-instructions.md \
    ~/.config/github-copilot/intellij/global-agents-instructions.md
  ln -sf "$(pwd)"/config/copilot/intellij/global-copilot-instructions.md \
    ~/.config/github-copilot/intellij/global-copilot-instructions.md
}

uninstall() {
  log "Uninstall Copilot and IntelliJ configuration"

  rm -f ~/.config/github-copilot/intellij/global-git-commit-instructions.md
  rm -f ~/.config/github-copilot/intellij/global-agents-instructions.md
  rm -f ~/.config/github-copilot/intellij/global-copilot-instructions.md

  rmdir ~/.config/github-copilot/intellij 2>/dev/null || true
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
