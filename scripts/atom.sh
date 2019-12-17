#!/usr/bin/env bash
#
# atom.sh
#
# Install Atom packages using the Atom Package Manager

# shellcheck disable=SC2230

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

install () {
  if test "$(which atom)"; then
    apm_pkgs=(
    ansible-vault
    atom-beautify
    atom-jinja2
    autocomplete-ansible
    autocomplete-python
    busy-signal
    blame
    editorconfig
    file-icons
    git-plus
    git-time-machine
    highlight-selected
    ide-json
    ide-python
    language-ansible
    language-chef
    language-docker
    language-groovy
    language-hcl
    language-terraform
    linter
    linter-ansible-linting
    linter-jenkins
    linter-js-yaml
    linter-jsonlint
    linter-markdown
    linter-shellcheck
    linter-terraform-syntax
    linter-ui-default
    open-recent
    python-black
    terraform-fmt
    todo-show
    )
    log "Install Atom Packages"
    apm install "${apm_pkgs[@]}"
  else
    log "Atom not found. Unable to install Atom Packages."
  fi
}

uninstall () {
  if [ -d ~/.atom ]; then
    log "Remove Atom settings and configuration"
    rm -rf ~/.atom
    rm -rf ~/.atom
    rm -rf /usr/local/bin/atom
    rm -rf /usr/local/bin/apm
    rm -rf ~/Library/Preferences/com.github.atom.plist
    rm -rf ~/Library/Application Support/com.github.atom.ShipIt
    rm -rf ~/Library/Application Support/Atom
    rm -rf ~/Library/Saved Application State/com.github.atom.savedState
    rm -rf ~/Library/Caches/com.github.atom
    rm -rf ~/Library/Caches/Atom
  fi
}

case "$1" in
  "--install" )
  install ;;
  "--uninstall" )
  uninstall ;;
  * )
  usage ;;
esac
