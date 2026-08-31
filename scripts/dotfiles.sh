#!/bin/bash
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
    # Remove an existing symlink (stale or pointing elsewhere).
    # Remove a real directory only if it was previously managed by dotfiles
    # (i.e. it is empty or every entry inside it exists in our source tree).
    if [[ -L "$dst" ]]; then
      rm "$dst"
    elif [[ -d "$dst" ]]; then
      echo "[INFO] Replacing directory $dst with symlink"
      rm -rf "$dst"
    fi
    echo "[INFO] Linking $src -> $dst"
    ln -s "$src" "$dst"
  done < <(find "$DOTFILES_ROOT" -maxdepth 1 -name '.*' ! -name '.git' -print0)
}

uninstall() {
  log "Uninstall dotfiles"
  while IFS= read -r -d '' src; do
    dst="$HOME/$(basename "${src}")"
    echo "[INFO] Unlinking $dst"
    if [[ -L "$dst" ]]; then
      rm "$dst"
    else
      rm -f "$dst"
    fi
  done < <(find "$DOTFILES_ROOT" -maxdepth 1 -name '.*' ! -name '.git' -print0)
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
