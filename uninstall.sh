#!/usr/bin/env bash
#
# bootstrap-uninstall.sh
#
# Unstrap local workstation

set -o errexit -o nounset -o pipefail

cd "$(dirname "${BASH_SOURCE}")";

./scripts/brew.sh -i
./scripts/rvm.sh -i
./scripts/vim.sh -i
./scripts/dotfiles.sh -i
