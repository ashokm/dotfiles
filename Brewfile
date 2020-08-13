if OS.linux?
  tap "linuxbrew/xorg"
  brew "gcc"
  brew "adoptopenjdk@11"
end

tap "homebrew/bundle"
tap "homebrew/core"

brew "openssl@1.1"
brew "awscli"
brew "bash"
brew "bash-completion@2"
brew "bat"
brew "csshx"
brew "curl"
brew "direnv"
brew "git"
brew "git-archive-all"
brew "git-crypt"
brew "git-flow-avh"
brew "git-lfs"
brew "gnu-sed"
brew "python"
brew "shellcheck"
brew "tree"
brew "watch"
brew "wget"

if OS.mac?
  cask_args appdir: "/Applications"
  tap "homebrew/cask"
  tap "adoptopenjdk/openjdk"

  brew "ffmpeg"
  brew "gnupg"
  brew "vim"
  brew "youtube-dl"

  cask "1password"
  cask "adoptopenjdk11"
  cask "corona-tracker"
  cask "cyberduck"
  cask "docker"
  cask "dropbox"
  cask "evernote"
  cask "firefox"
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
  cask "skype"
  cask "spotify"
  cask "vlc"
  cask "whatsapp"
  cask "zoomus"
end
