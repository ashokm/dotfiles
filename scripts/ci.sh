#!/usr/bin/env bash
#
# ci.sh
#
# CI build related tasks

# See links below for installed software:
# https://github.com/microsoft/azure-pipelines-image-generation/tree/master/images
# https://github.com/actions/virtual-environments/tree/main/images

set -o errexit -o nounset -o pipefail

usage() {
  echo "Usage: $0"
}

log() {
  echo "================================================================================"
  echo "$@" | sed -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

CI_ENABLED=${CI:-}

if [[ "${CI_ENABLED}" ]]; then
  if test "$(command -v brew)"; then
    # Uninstall unwanted pre-installed packages on CI build agent
    log "Uninstall unwanted pre-installed packages on CI build agent"
    BREW_PACKAGES=('aws-sam-cli' 'session-manager-plugin' 'openssl@1.0.2t' 'python@2.7.17')
    for package in "${BREW_PACKAGES[@]}"; do
      brew uninstall --force "$package"
    done
    BREW_CASK_PACKAGES=('chromedriver' 'google-chrome')
    for package in "${BREW_CASK_PACKAGES[@]}"; do
      brew cask uninstall --force "$package"
    done
    FILES="/usr/local/bin/aws
    /usr/local/aws-cli/aws
    /usr/local/bin/aws_completer
    /usr/local/aws-cli/aws_completer"
    for file in $FILES; do
      if [ -f "$file" ]; then
        echo "[INFO] Removing $file ..."
        sudo rm "$file"
      fi
    done
  fi

  # Removing pre-installed Homebrew on CI build agent
  if test "$(command -v brew)"; then
    log "Removing pre-installed Homebrew on CI build agent"
    if test "$(uname -s)" = "Darwin"; then
      echo "[INFO] Uninstall packages installed using Brew cask ..."
      brew cask uninstall --force "$(brew list --cask)" && brew cask cleanup
    fi
    echo "[INFO] Uninstall packages installed using Brew ..."
    brew uninstall --force "$(brew list)" && brew cleanup

    HOMEBREW_UNINSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh"
    /bin/bash -c "$(curl -fsSL ${HOMEBREW_UNINSTALL_URL})"

    DIRS="/usr/local/Homebrew/
    /usr/local/Caskroom/
    /usr/local/Cellar/
    /usr/local/.com.apple.installer.keep
    /usr/local/Frameworks/
    /usr/local/aws-cli/
    /usr/local/bin/
    /usr/local/etc/
    /usr/local/include/
    /usr/local/lib/
    /usr/local/man/
    /usr/local/microsoft/
    /usr/local/miniconda/
    /usr/local/opt/
    /usr/local/sbin/
    /usr/local/share/
    /usr/local/var/
    /home/linuxbrew/"
    for dir in $DIRS; do
      if [ -d "$dir" ]; then
        echo "[INFO] Removing $dir ..."
        sudo rm -rf "$dir"
      fi
    done
  fi
fi
