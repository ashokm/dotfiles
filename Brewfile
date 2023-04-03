require 'etc'

# Some formulas are not ready for Apple Silicon,
# or we do not want to install these on M1 Macs
arch = Etc.uname[:machine]
is_m1 = arch == 'arm64'

tap "homebrew/bundle"
tap "homebrew/core"
tap "homebrew/cask"
tap "homebrew/cask-drivers"
tap "snyk/tap" if is_m1

brew "openssl@1.1"
brew "openjdk@11"
brew "openjdk@17"
brew "openjdk@19"
brew "awscli"
brew "bash"
brew "bash-completion@2"
brew "bat"
brew "csshx"
brew "curl"
brew "direnv"
brew "diff-so-fancy"
brew "git"
brew "git-lfs"
brew "gradle"
brew "gnupg"
brew "gnu-sed"
brew "maven"
brew "nvm"
if is_m1
    # https://github.com/Automattic/node-canvas
    brew "pkg-config"
    brew "cairo"
    brew "pango"
    brew "libpng"
    brew "jpeg"
    brew "giflib"
    brew "librsvg"
    brew "pixman"
    # https://docs.snyk.io/snyk-cli/install-the-snyk-cli#install-with-homebrew-macos-linux
    brew "snyk"
end
brew "shellcheck"
brew "tree"
brew "watch"
brew "wget"
brew "vim"
brew "yarn"

cask_args appdir: "~/Applications"

cask "1password"
cask "corona-tracker"
cask "displaylink"
cask "docker"
cask "dropbox" unless is_m1
cask "flux"
cask "google-chrome"
cask "intellij-idea-ce"
cask "intune-company-portal" if is_m1
cask "jiggler"
cask "logi-options-plus"
cask "menumeters"
cask "microsoft-auto-update" if is_m1
cask "microsoft-office" if is_m1
cask "microsoft-teams"
cask "nordvpn" unless is_m1
cask "rectangle"
cask "slack" if is_m1
cask "spotify"
cask "visual-studio-code" if is_m1
cask "vlc"
cask "zoom"
