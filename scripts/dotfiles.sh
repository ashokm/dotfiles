#!/bin/bash
#
# dotfiles.sh
#
# Symlink dotfiles to ${HOME}

set -o errexit -o nounset -o pipefail

DOTFILES_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../dotfiles" && pwd)"

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

create_git_identity_template() {
  local file="$1"
  local label="$2"

  if [[ -e "$file" ]]; then
    return
  fi

  cat > "$file" << EOF
# Update this file with your $label Git identity.
[user]
    name = Your Name
    email = your-$label-email@example.com
EOF

  echo "[INFO] Created $file. Update it with your details before making Git commits on this machine."
}

install() {
  local linked=0

  # Check all destinations first so a conflict cannot leave a partial refresh.
  check_link_targets
  # Remove old managed links, including links for dotfiles renamed or removed from the repo.
  remove_managed_links > /dev/null
  log "Install dotfiles"

  while IFS= read -r -d '' src; do
    dst="$HOME/$(basename "${src}")"
    if [[ -e "$dst" || -L "$dst" ]]; then
      echo "[ERROR] Cannot link $src: $dst already exists and is not managed by dotfiles." >&2
      return 1
    fi
    ln -s "$src" "$dst"
    linked=$((linked + 1))
  done < <(find "$DOTFILES_ROOT" -maxdepth 1 -name '.*' ! -name '.git' -print0)

  create_git_identity_template "$HOME/.gitconfig-home" "home"
  create_git_identity_template "$HOME/.gitconfig-work" "work"

  echo "[INFO] Linked $linked dotfiles"
}

check_link_targets() {
  local src
  local dst
  local target

  while IFS= read -r -d '' src; do
    dst="$HOME/$(basename "$src")"
    if [[ -e "$dst" || -L "$dst" ]]; then
      if [[ -L "$dst" ]]; then
        target="$(readlink "$dst")"
        if [[ "$target" == "$DOTFILES_ROOT/"* ]]; then
          continue
        fi
      fi
      echo "[ERROR] Cannot link $src: $dst already exists and is not managed by dotfiles." >&2
      return 1
    fi
  done < <(find "$DOTFILES_ROOT" -maxdepth 1 -name '.*' ! -name '.git' -print0)
}

remove_managed_links() {
  local unlinked=0
  local target

  # Only remove symlinks whose targets are within this repository's dotfiles directory.
  while IFS= read -r -d '' dst; do
    target="$(readlink "$dst")"
    if [[ "$target" == "$DOTFILES_ROOT/"* ]]; then
      rm "$dst"
      unlinked=$((unlinked + 1))
    fi
  done < <(find "$HOME" -maxdepth 1 -type l -print0)

  printf '%s\n' "$unlinked"
}

uninstall() {
  log "Uninstall dotfiles"
  local unlinked
  unlinked="$(remove_managed_links)"
  echo "[INFO] Unlinked $unlinked dotfiles"
}

case "${1:-}" in
"--install")
  install
  ;;
"--uninstall")
  uninstall
  ;;
*)
  usage
  ;;
esac
