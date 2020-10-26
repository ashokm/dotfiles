#!/usr/bin/env bash
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
  ./scripts/ci.sh
  ./scripts/xcode.sh "$@"
  ./scripts/update.sh "$@"
  ./scripts/linux.sh "$@"
  ./scripts/ssh.sh "$@"
  ./scripts/dotfiles.sh "$@"
  ./scripts/vim.sh "$@"
  ./scripts/brew.sh "$@"
  ;;
"--uninstall")
  ./scripts/vim.sh "$@"
  ./scripts/brew.sh "$@"
  ./scripts/dotfiles.sh "$@"
  ./scripts/linux.sh "$@"
  ./scripts/xcode.sh "$@"
  ;;
*)
  usage && exit
  ;;
esac
