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
  ;;
  "--uninstall" )
  ;;
  * )
  usage && exit;;
esac

./scripts/dotfiles.sh "$@"
./scripts/vim.sh "$@"
./scripts/rvm.sh "$@"
./scripts/brew.sh "$@"
./scripts/update.sh
