#!/bin/bash
#
# vscode.sh
#
# Customize Visual Studio Code settings

set -o errexit -o nounset -o pipefail

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

if brew list --cask | grep -q 'visual-studio-code'; then
  log "Customize VS Code settings"
  echo "[INFO] Manage VS Code settings ..."
  ln -sfv "${HOME}"/.dotfiles/config/vscode/settings.json "${HOME}"/Library/Application\ Support/Code/User
  echo "[INFO] Manage VS Code extensions ..."
  EXTENSION_LIST_FILE="${HOME}"/.dotfiles/config/vscode/extensions.txt
  for extension in $(cat "$EXTENSION_LIST_FILE"); do
    code --install-extension "$extension" --force
  done

  for extension in $(code --list-extensions | diff --new-line-format='%L' --old-line-format='' --unchanged-line-format='' $EXTENSION_LIST_FILE -); do
    code --uninstall-extension "$extension"
  done
else
  log "VS Code not found"
fi
