#!/bin/bash
#
# update.sh
#
# `update` handles installation, updates, things like that. Run it periodically
# to make sure you're on the latest and greatest.

set -o errexit -o nounset

usage() {
  echo "Usage: $0"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

# Update OS Software
log "Running macOS Software updates"
sudo softwareupdate --install --all

# For M1 Macs
if test "$(uname -m)" = "arm64"; then
  if test ! "$(/usr/bin/pgrep oahd)"; then
    log "Install Rosetta 2"
      sudo softwareupdate --install-rosetta --agree-to-license
    else
      log "Rosetta 2 already installed"
    fi
fi

# Update Brew
"$(dirname "$0")"/brew.sh --update

# Update Conda
"$(dirname "$0")"/miniconda.sh --update
