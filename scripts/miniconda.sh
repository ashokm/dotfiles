#!/bin/bash
#
# miniconda.sh
#
# Install Miniconda

set -o errexit -o nounset -o pipefail

usage() {
	echo "Usage: $0 [--install | --uninstall | --update]"
}

log() {
	echo "================================================================================"
	echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
	echo "================================================================================"
}

install() {
	if test ! "$(command -v conda)"; then
		log "Install Miniconda"
		if test "$(uname -m)" = "arm64"; then
			MINICONDA_MACOSX_INSTALL_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
		elif test "$(uname -m)" = "x86_64"; then
			MINICONDA_MACOSX_INSTALL_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
		fi
		echo "Downloading Miniconda ..."
		curl -fsSL "${MINICONDA_MACOSX_INSTALL_URL}" -o /tmp/Miniconda3-latest-MacOSX.sh
		echo "Installing Miniconda ..."
		chmod +x /tmp/Miniconda3-latest-MacOSX.sh
		/tmp/Miniconda3-latest-MacOSX.sh -b && rm -rf /tmp/Miniconda3-latest-MacOSX.sh
	else
		log "Miniconda already installed"
	fi
}

uninstall() {
	if test "$(command -v conda)"; then
		log "Uninstall Miniconda"

		DIRS="$HOME/miniconda3/
    $HOME/.conda/"

		for dir in $DIRS; do
			if [ -d "$dir" ]; then
				echo "[INFO] Removing $dir ..."
				sudo rm -rf "$dir"
			fi
		done

	else
		log "Miniconda already uninstalled"
	fi
}

update() {
	if test "$(command -v conda)"; then
		log "Updating Conda"
		conda update conda -y
	fi
}

case "$1" in
"--install")
	install
	;;
"--uninstall")
	uninstall
	;;
"--update")
	update
	;;
*)
	usage
	;;
esac
