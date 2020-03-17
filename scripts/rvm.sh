#!/usr/bin/env bash
#
# rvm.sh
#
# Install RVM

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install () {
    log "Install RVM"
    if test ! "$(command -v rvm)"; then
      gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
      curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles
    fi
}

uninstall () {
    log "Uninstall RVM"
    if test "$(command -v rvm)"; then
      rvm implode
      echo "[INFO] Removing rm -rf ~/.rvm" && rm -rf ~/.rvm
    fi
}

case "$1" in
  "--install" )
  install ;;
  "--uninstall" )
  uninstall ;;
  * )
  usage ;;
esac
