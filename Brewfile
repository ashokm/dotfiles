tap "homebrew/bundle"
tap "homebrew/core"
tap "homebrew/cask" if OS.mac?
tap "adoptopenjdk/openjdk" if OS.mac?
tap "linuxbrew/xorg" if OS.linux?

brew "gcc" if OS.linux?
brew "openssl@1.1"
brew "awscli"
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
brew "gnupg"
brew "gnu-sed"
brew "shellcheck"
brew "tree"
brew "watch"
brew "wget"
brew "vim"
brew "youtube-dl" if OS.mac?

if OS.mac?
  cask_args appdir: "/Applications"

  cask "1password"
  cask "adoptopenjdk"
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
  cask "zoomus"
end
