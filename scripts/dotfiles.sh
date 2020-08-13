#!/usr/bin/env bash
#
# dotfiles.sh
#
# Symlink dotfiles to ${HOME}

set -o errexit -o nounset -o pipefail

DOTFILES_ROOT="$(pwd)/dotfiles"

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install() {
  log "Install dotfiles"
  while IFS= read -r -d '' src; do
    dst="$HOME/$(basename "${src}")"
    echo "[INFO] Linking $src -> $dst"
    ln -F -s "$src" "$dst"
  done < <(find "$DOTFILES_ROOT" -name '.*' ! -name '.git' -print0)
}

uninstall() {
  log "Uninstall dotfiles"
  while IFS= read -r -d '' src; do
    dst="$HOME/$(basename "${src}")"
    echo "[INFO] Unlinking $dst"
    rm -f "$dst"
  done < <(find "$DOTFILES_ROOT" -name '.*' ! -name '.git' -print0)
}

case "$1" in
"--install")
  uninstall && install
  ;;
"--uninstall")
  uninstall
  ;;
*)
  usage
  ;;
esac

# TODO:
# Fix shellcheck SC2044 and SC2086 in this file
# Add function to find and cleanup broken symlinks in $HOME
