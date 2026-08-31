#!/bin/bash
#
# ssh.sh
#
# Setup SSH keys
#
# Key strategy:
#   ~/.ssh/id_ed25519      — ED25519, used for GitHub and all modern services
#   ~/.ssh/id_rsa_azure    — RSA 4096, used for Azure DevOps (no ED25519 support)
#
# ~/.ssh/config routes each host to the correct key automatically.

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

write_ssh_config() {
  local config_file="$HOME/.ssh/config"
  local begin_marker="# >>> dotfiles managed ssh block >>>"
  local end_marker="# <<< dotfiles managed ssh block <<<"
  local temp_file

  temp_file="$(mktemp)"

  # Preserve user-managed config and only replace our managed block when present.
  if [ -e "$config_file" ]; then
    if grep -qF "$begin_marker" "$config_file" && grep -qF "$end_marker" "$config_file"; then
      awk -v begin="$begin_marker" -v end="$end_marker" '
        $0 == begin { skip = 1; next }
        $0 == end { skip = 0; next }
        !skip { print }
      ' "$config_file" > "$temp_file"
    else
      cat "$config_file" > "$temp_file"
    fi
  else
    : > "$temp_file"
  fi

  log "Converging managed ~/.ssh/config section"
  if [ -s "$temp_file" ]; then
    printf "\n" >> "$temp_file"
  fi

  cat >> "$temp_file" << EOF
$begin_marker
# ─── Azure DevOps ─────────────────────────────────────────────────────────────
# Azure DevOps does not support ED25519 keys; RSA 4096 is required.
Host ssh.dev.azure.com
  IdentityFile ~/.ssh/id_rsa_azure
  IdentitiesOnly yes

# ─── GitHub & all other services ──────────────────────────────────────────────
Host github.com
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes

# Catch-all: prefer ED25519 for everything else
Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
$end_marker
EOF

  mv "$temp_file" "$config_file"
  chmod 600 "$config_file"
}

if [ -z "${CI:-}" ]; then
  if [ ! -d ~/.ssh ]; then
    log "Creating ~/.ssh"
    mkdir ~/.ssh
  fi

  # Always enforce secure permissions even when ~/.ssh already exists.
  chmod 700 ~/.ssh
  touch ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys

  # ── ED25519 key (GitHub, GitLab, Bitbucket, etc.) ──────────────────────────
  if [ -e ~/.ssh/id_ed25519.pub ]; then
    log "ED25519 SSH key already exists (~/.ssh/id_ed25519)"
  else
    log "Generating ED25519 SSH key (~/.ssh/id_ed25519)"
    echo -n "Enter email for SSH key generation: "
    read -r email
    ssh-keygen -t ed25519 -C "${email}" -f ~/.ssh/id_ed25519
  fi

  # ── RSA 4096 key (Azure DevOps — no ED25519 support) ───────────────────────
  if [ -e ~/.ssh/id_rsa_azure.pub ]; then
    log "Azure DevOps RSA key already exists (~/.ssh/id_rsa_azure)"
  else
    log "Generating RSA 4096 SSH key for Azure DevOps (~/.ssh/id_rsa_azure)"
    if [ -z "${email:-}" ]; then
      echo -n "Enter email for Azure DevOps SSH key generation: "
      read -r email
    fi
    ssh-keygen -t rsa -b 4096 -C "${email} (azure-devops)" -f ~/.ssh/id_rsa_azure
  fi

  # Harden key file permissions in case they were created/changed externally.
  [ -e ~/.ssh/id_ed25519 ] && chmod 600 ~/.ssh/id_ed25519
  [ -e ~/.ssh/id_ed25519.pub ] && chmod 644 ~/.ssh/id_ed25519.pub
  [ -e ~/.ssh/id_rsa_azure ] && chmod 600 ~/.ssh/id_rsa_azure
  [ -e ~/.ssh/id_rsa_azure.pub ] && chmod 644 ~/.ssh/id_rsa_azure.pub

  write_ssh_config
else
  log "Skipping creation of ~/.ssh"
fi
