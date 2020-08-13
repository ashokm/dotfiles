#!/usr/bin/env bash
#
# vim.sh
#
# Setup Vim

set -o errexit -o nounset -o pipefail

VIM_ROOT="$HOME/.vim"
VIM_DIRS="backups colors swaps undo"

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install() {
  log "Install vim dependencies"
  if [ ! -d "$VIM_ROOT" ]; then
    echo "[INFO] Creating $VIM_ROOT ..."
    mkdir "$VIM_ROOT"
  fi
  for dir in $VIM_DIRS; do
    VIM_DIR="${VIM_ROOT}/${dir}"
    if [ ! -d "$VIM_DIR" ]; then
      echo "[INFO] Creating $VIM_DIR ..."
      mkdir "$VIM_DIR"
    fi
  done
  # Vim color scheme install
  echo "[INFO] Installing vim wombat color scheme ..."
  echo ''
  if [ -d "$VIM_ROOT/colors" ]; then
    rm -rf "${VIM_ROOT}/colors"
  fi
  git clone https://github.com/sheerun/vim-wombat-scheme.git "${VIM_ROOT}"/colors/wombat
  mv "${VIM_ROOT}"/colors/wombat/colors/* "${VIM_ROOT}"/colors/ && rm -rf "${VIM_ROOT}"/colors/wombat
}

uninstall() {
  log "Uninstall vim dependencies"
  for dir in $VIM_DIRS; do
    VIM_DIR="${VIM_ROOT}/${dir}"
    if [ -d "$VIM_DIR" ]; then
      echo "[INFO] Removing $VIM_DIR ..."
      rm -rf "$VIM_DIR"
    fi
  done
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
