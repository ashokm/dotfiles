#!/bin/bash
#
# update.sh
#
# `update` handles installation, updates, things like that. Run it periodically
# to make sure you're on the latest and greatest.

set -o errexit -o nounset -o pipefail

is_noninteractive() {
  [ -n "${CI:-}" ] || [ -n "${NONINTERACTIVE:-}" ]
}

usage() {
  echo "Usage: $0"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

# Update OS Software
if ! is_noninteractive; then
  log "macOS Software updates"
  # Check first so a machine with no available updates does not prompt for sudo.
  if output="$(softwareupdate --list 2>&1)"; then
    if [[ "$output" == *"No updates are available."* || "$output" == *"No new software available."* ]]; then
      echo "[INFO] macOS is up to date."
    else
      printf '%s\n' "$output"
      sudo softwareupdate --install --all
    fi
  else
    status=$?
    printf '%s\n' "$output" >&2
    exit "$status"
  fi
else
  log "Skipping macOS Software updates in non-interactive mode"
fi

# For Apple silicon
if test "$(uname -m)" = "arm64" && ! is_noninteractive; then
  if test ! "$(/usr/bin/pgrep oahd)"; then
    log "Install Rosetta 2"
    sudo softwareupdate --install-rosetta --agree-to-license
  fi
fi

# Update Brew
"$(dirname "$0")"/brew.sh --update
echo "[INFO] System update checks complete."
