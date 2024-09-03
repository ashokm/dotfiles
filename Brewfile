# Some formulas are not ready for Apple Silicon,
# or we do not want to install these arm64 architectures
is_apple_silicon = `uname -v`.include? "RELEASE_ARM64"

# Tap repositories
tap "homebrew/bundle"

# Added for local Backstage development
brew "corepack"
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

# Homebrew packages
brew "openjdk@11"
brew "openjdk@17"
brew "openjdk@21"
brew "awscli"
brew "bash"
brew "bash-completion@2"
brew "bat"
brew "black"
brew "csshx"
brew "curl"
brew "diff-so-fancy"
brew "direnv"
brew "flake8"
brew "git"
brew "git-lfs"
brew "gnu-sed"
brew "gnupg"
brew "gradle"
brew "jq"
brew "maven"
brew "nvm"
brew "shellcheck"
brew "starship"
brew "tree"
brew "vim"
brew "watch"
brew "wget"

# Cask packages
cask_args appdir: "/Applications"
cask "1password"
cask "displaylink"
cask "docker"
cask "font-fira-code-nerd-font"
cask "flux"
cask "garmin-express"
cask "google-chrome"
cask "intellij-idea" if is_apple_silicon
cask "intellij-idea-ce" if not is_apple_silicon
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
cask "zoom"

