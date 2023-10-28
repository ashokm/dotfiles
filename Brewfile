# Some formulas are not ready for Apple Silicon,
# or we do not want to install these arm64 architectures
is_apple_silicon = `uname -v`.include? "RELEASE_ARM64"

# Tap repositories
tap "homebrew/bundle"
tap "homebrew/cask-fonts"
tap "homebrew/core" if is_apple_silicon
tap "snyk/tap" if is_apple_silicon

# Homebrew packages
brew "openjdk@11"
brew "openjdk@17"
brew "awscli"
brew "bash"
brew "bash-completion@2"
brew "bat"
brew "csshx"
brew "curl"
brew "diff-so-fancy"
brew "direnv"
brew "git"
brew "git-lfs"
brew "gnu-sed"
brew "gnupg"
brew "gradle"
brew "maven"
brew "nvm"
brew "shellcheck"
brew "starship"
brew "tree"
brew "vim"
brew "watch"
brew "wget"
brew "yarn"
brew "snyk" if is_apple_silicon

# https://github.com/Automattic/node-canvas
if is_apple_silicon
    brew "pkg-config"
    brew "cairo"
    brew "pango"
    brew "libpng"
    brew "jpeg"
    brew "giflib"
    brew "librsvg"
    brew "pixman"
end

# Cask packages
cask_args appdir: "/Applications"
cask "1password"
cask "android-commandlinetools" if is_apple_silicon
cask "corona-tracker"
cask "displaylink"
cask "docker"
cask "dropbox" unless is_apple_silicon
cask "font-fira-code-nerd-font"
cask "flux"
cask "google-chrome"
cask "intellij-idea-ce"
cask "intune-company-portal" if is_apple_silicon
cask "jiggler"
cask "logi-options-plus"
cask "menumeters"
cask "microsoft-auto-update" if is_apple_silicon
cask "microsoft-office" if is_apple_silicon
cask "microsoft-teams"
cask "nordvpn" unless is_apple_silicon
cask "rectangle"
cask "slack" if is_apple_silicon
cask "spotify"
cask "visual-studio-code" if is_apple_silicon
cask "vlc"
cask "zoom"
