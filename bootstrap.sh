#!/usr/bin/env bash
#
# bootstrap.sh
#
# Bootstrap local workstation

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

cd "$(dirname "${BASH_SOURCE[@]}")";

case "$1" in
  "--install" )
    ./scripts/update.sh
    ./scripts/ssh.sh
    ./scripts/xcode.sh "$@"
    ./scripts/vim.sh "$@"
    ./scripts/rvm.sh "$@"
    ./scripts/brew.sh "$@"
    ./scripts/dotfiles.sh "$@"
  ;;
  "--uninstall" )
    ./scripts/rvm.sh "$@"
    ./scripts/vim.sh "$@"
    ./scripts/brew.sh "$@"
    ./scripts/xcode.sh "$@"
    ./scripts/dotfiles.sh "$@"
  ;;
  * )
  usage && exit;;
esac
