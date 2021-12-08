#!/usr/bin/env bash
#
# linux.sh
#
# Install Linux software (that is not available via Homebrew)

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

# shellcheck disable=SC2032
install() {
  # Install Linux software
  log "Install Linux software"
  # Install specific packages on WSL
  if [[ "$(</proc/sys/kernel/osrelease)" == *microsoft* ]]; then
    WSL_PACKAGES="python2-minimal"
  else
    WSL_PACKAGES=""
  fi
  # shellcheck disable=SC2033
  sudo apt install build-essential gnupg2 "${WSL_PACKAGES}" -y
  log "Install Yarn"
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  # shellcheck disable=SC2033
  sudo apt update && sudo apt install yarn -y
}

uninstall() {
  # Uninstall Linux software
  log "Uninstall Yarn"
  sudo rm -rf /etc/apt/sources.list.d/yarn.list
  sudo apt purge yarn -y
  log "Uninstall Linux software"
  # Uninstall specific packages on WSL
  if [[ "$(</proc/sys/kernel/osrelease)" == *microsoft* ]]; then
    WSL_PACKAGES="python2-minimal"
  else
    WSL_PACKAGES=""
  fi
  sudo apt purge build-essential gnupg2 "${WSL_PACKAGES}" -y && sudo apt autoremove -y
}

if test "$(uname -s)" = "Linux"; then
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
fi
