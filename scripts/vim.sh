#!/usr/bin/env bash
#
# vim.sh
#
# Setup Vim

set -o errexit -o nounset -o pipefail

VIM_ROOT="$HOME/.vim"
VIM_DIRS="backups swaps undo"

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"

}

install () {
    log "Install vim dependencies"
    for dir in $VIM_DIRS; do
      VIM_DIR="${VIM_ROOT}/${dir}"
      if [ ! -d "$VIM_DIR" ]; then
        echo "Creating $VIM_DIR ..."
        mkdir "$VIM_DIR"
      fi
    done
}

uninstall () {
    log "Uninstall vim dependencies"
    for dir in $VIM_DIRS; do
      VIM_DIR="${VIM_ROOT}/${dir}"
      if [ -d "$VIM_DIR" ]; then
        echo "Removing $VIM_DIR ..."
        rm -rf "$VIM_DIR"
      fi
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
