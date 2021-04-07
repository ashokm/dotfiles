tap "homebrew/bundle"
tap "homebrew/core"
tap "homebrew/cask" if OS.mac?
tap "AdoptOpenJDK/openjdk" if OS.mac?
tap "aws/tap"

brew "gcc" if OS.linux?
brew "openssl@1.1"
brew "adoptopenjdk@11" if OS.linux?
brew "awscli"
brew "aws-sam-cli"
brew "bash"
brew "bash-completion@2"
brew "bat"
brew "cfn-lint"
brew "csshx"
brew "curl"
brew "direnv"
brew "ffmpeg" if OS.mac?
brew "git"
brew "git-archive-all"
brew "git-crypt"
brew "git-flow-avh"
brew "git-lfs"
brew "gradle"
brew "gnupg" if OS.mac?
brew "gnu-sed"
brew "nvm"
brew "shellcheck"
brew "tree"
brew "watch"
brew "wget"
brew "vim"
brew "youtube-dl" if OS.mac?

if OS.mac?
  cask_args appdir: "/Applications"

  cask "1password"
  cask "adoptopenjdk/openjdk/adoptopenjdk11"
  cask "corona-tracker"
  cask "cyberduck"
  cask "docker"
  cask "dropbox"
  cask "evernote"
  cask "flux"
  cask "google-chrome"
  cask "google-photos-backup-and-sync"
  cask "gpg-suite"
  cask "intellij-idea-ce"
  cask "jiggler"
  cask "keybase"
  cask "menumeters"
  cask "microsoft-teams"
  cask "nordvpn"
  cask "sizeup"
  cask "spotify"
  cask "spotmenu"
  cask "vlc"
  cask "whatsapp"
  cask "zoom"
end
