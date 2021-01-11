#!/usr/bin/env bash
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
if test "$(uname -s)" = "Darwin"; then
  log "Running macOS Software updates"
  sudo softwareupdate --install --all
elif test "$(uname -s)" = "Linux"; then
  log "Running Linux Software updates"
  sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean
fi

# Update Brew
if test "$(command -v brew)"; then
  # Ensure we're using the latest version of Homebrew.
  log "Updating Homebrew"
  brew update

  # Checking your Homebrew system for potential problems
  log "Checking your Homebrew system for potential problems"
  brew cleanup
  brew doctor || true

  # Upgrade any already-installed packages.
  log "Updating installed Homebrew packages"
  brew upgrade
  if test "$(uname -s)" = "Darwin"; then
    brew upgrade --cask
  fi
fi

# Update Conda
if test "$(command -v conda)"; then
  log "Updating Conda"
  conda update conda -y
fi
