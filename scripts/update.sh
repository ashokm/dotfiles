#!/bin/sh
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
  echo "$@" | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

# Update OS Software
if test "$(uname -s)" = "Darwin"
then
  log "Running OS X Software updates"
  sudo softwareupdate --install --all
elif test "$(uname -s)" = "Linux"
then
  log "Running Ubuntu Linux Software updates"
  sudo apt-get update -y && sudo apt-get upgrade -y
fi

# Update Brew
if test "$(which brew)"
then
  # Check your system for potential problems
  log "Check your system for potential problems"
  brew doctor

  # Ensure we’re using the latest version of Homebrew.
  log "Updating Homebrew"
  brew update

  # Upgrade any already-installed formulae.
  log "Updating installed formulae"
  brew upgrade
  brew cask upgrade
fi

# Update RVM
if test "$(which rvm)"
then
  # Upgrade the RVM installation.
  log "Upgrading the RVM installation"
  rvm get stable --ignore-dotfiles
  rvm reload
fi
