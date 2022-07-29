#!/bin/bash
#
# bootstrap.sh
#
# Bootstrap local workstation

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

cd "$(dirname "${BASH_SOURCE[@]}")"

case "$1" in
"--install")
  ./scripts/xcode.sh "$@"
  ./scripts/update.sh "$@"
  ./scripts/ssh.sh "$@"
  ./scripts/dotfiles.sh "$@"
  ./scripts/vim.sh "$@"
  ./scripts/brew.sh "$@"
  ./scripts/miniconda.sh "$@"
  ;;
"--uninstall")
  ./scripts/miniconda.sh "$@"
  ./scripts/vim.sh "$@"
  ./scripts/brew.sh "$@"
  ./scripts/dotfiles.sh "$@"
  ./scripts/xcode.sh "$@"
  ;;
*)
  usage && exit
  ;;
esac
