#!/usr/bin/env bash
#
# ssh.sh
#
# Setup SSH keys

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0"
}

log() {
  echo "================================================================================"
  echo "$@" | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

if [ ! -d ~/.ssh ]; then
  log "Creating ~/.ssh ..."
  mkdir ~/.ssh
  chmod 700 ~/.ssh
  touch ~/.ssh/authorized_keys
  chmod 640 ~/.ssh/authorized_keys
fi

if [ -e ~/.ssh/id_rsa.pub ]; then
	log "SSH key already exists"
else
  log "Generating SSH key ..."
  echo -n "Enter email for SSH key generation: "
  read email
	ssh-keygen -t rsa -C $email
fi
