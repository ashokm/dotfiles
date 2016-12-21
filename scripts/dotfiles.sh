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
  echo "$@" | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"

}

install () {
    log "Install dotfiles"
    for src in $(find $DOTFILES_ROOT -name '.*' ! -name '.git')
    do
        dst="$HOME/$(basename "${src}")"
        echo "Linking $src -> $dst"
        ln -F -s "$src" "$dst"
    done
}

uninstall () {
    log "Uninstall dotfiles"
    for src in $(find $DOTFILES_ROOT -name '.*' ! -name '.git')
    do
        dst="$HOME/$(basename "${src}")"
        echo "Unlinking $dst"
        rm -f "$dst"
    done
}

case "$1" in
  "--install" )
  install ;;
  "--uninstall" )
  uninstall ;;
  * )
  usage ;;
esac

# TODO:
# Fix shellcheck SC2044 and SC2086 in this file
# Add function to find and cleanup broken symlinks in $HOME
