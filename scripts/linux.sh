#!/usr/bin/env bash
#
# linux.sh
#
# Manage linux software using apt Package Manager or Snap Packages

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0 [--install | --uninstall]"
}

log() {
  echo "================================================================================"
  echo "$@" | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

declare -a apt_packages=(
	ansible
	awscli
	build-essential
	chromium-browser
	curl
	direnv
	docker
	firefox
	git
	git-review
	gradle
	maven
	nautilus-dropbox
	nodejs
	packer
	perl
	ruby
	shellcheck
	tree
	vagrant
	vim
	virtualbox
	vlc
	watch
	wget
	youtube-dl
)

declare -a snap_packages=(
	kubectl
	spotify
	slack
	terraform
	terragrunt
)

declare -a bloatware=(
	libreoffice*
	shotwell-*
	thunderbird*
	rhythmbox
	cheese
	orca
	sinple-scan
	aisleriot
	gnome-mahjongg
	gnome-sudoku
	gnome-mines
)

install () {
  if test "$(uname -s)" = "Linux"
  then
    log "Removing bloatware"
    sudo rm -rf /usr/share/applications/ubuntu-amazon-default.desktop
    for package in "${bloatware[@]}"; do
      sudo apt-get remove ${package} --purge --yes
      sudo apt-get clean --yes
      sudo apt-get autoremove --yes
    done

    log "Installing apt packages"
    for package in "${apt_packages[@]}"; do
      echo "[INFO] Installing ${package} ..."
      sudo apt install ${package} --yes
    done

    log "Installing snap packages"
    for package in "${snap_packages[@]}"; do
      sudo snap install ${package}
    done
  fi
}

uninstall () {
  if test "$(uname -s)" = "Linux"
  then
    log "Uninstalling apt packages"
    for package in "${apt_packages[@]}"; do
      sudo apt purge ${package} --yes
    done

    log "Uninstalling snap packages"
    for package in "${snap_packages[@]}"; do
      echo "[INFO] Uninstalling ${package} ..."
      sudo snap remove ${package}
    done

    sudo apt autoremove --yes
    sudo apt autoclean
    sudo apt clean
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
