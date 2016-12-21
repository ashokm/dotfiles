#!/bin/sh
#
# update.sh
#
# `update` handles installation, updates, things like that. Run it periodically
# to make sure you're on the latest and greatest.

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0"
}

log() {
  echo "================================================================================"
  echo "$@" | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"

}

# Update OS X Software
log "Running OS X Software updates"
sudo softwareupdate -i -a

# Check your system for potential problems
log "Check your system for potential problems"
brew doctor

# Ensure we’re using the latest version of Homebrew.
log "Updating Homebrew"
brew update

# Upgrade any already-installed formulae.
log "Updating installed formulae"
brew upgrade

# Upgrade the RVM installation.
log "Upgrading the RVM installation"
rvm get stable --ignore-dotfiles
rvm reload
