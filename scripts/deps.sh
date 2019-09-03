#!/usr/bin/env bash
#
# deps.sh
#
# Install dependencies

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0"
}

log() {
  echo "================================================================================"
  echo "$@" | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

if test "$(uname -s)" = "Linux"
then
  log "Installing dependencies for Debian or Ubuntu ..."
  sudo apt-get install build-essential curl file git -y
  log "Installing other packages for Debian or Ubuntu ..."
  sudo apt-get install gnome-screensaver -y
fi
