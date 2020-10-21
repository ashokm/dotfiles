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

CI_ENABLED=${CI:-}

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
  # Check your Homebrew system for potential problems
  if [[ -z "${CI_ENABLED}" ]]; then
    echo "[INFO] Check your Homebrew system for potential problems ..."
    brew cleanup
    brew doctor
  else
    echo "[ci-skip] Check your Homebrew system for potential problems ..."
  fi

  # Ensure we’re using the latest version of Homebrew.
  if [[ -z "${CI_ENABLED}" ]]; then
    log "Updating Homebrew"
    brew update
  fi

  # Upgrade any already-installed formulae.
  log "Updating installed Homebrew formulae"
  brew upgrade
  if test "$(uname -s)" = "Darwin"; then
    brew upgrade --cask
  fi
fi
