# shellcheck shell=bash

# Suppress macOS Catalina verbose message to use zsh as the default login shell
# https://support.apple.com/en-gb/HT208050
export BASH_SILENCE_DEPRECATION_WARNING=1

##################################################
# PATH
##################################################
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,extra}; do
  # shellcheck disable=SC1090
  [ -r "$file" ] && [ -f "$file" ] && . "$file";
done;
unset file;

##################################################
# Homebrew
##################################################
# Intel processor
if [ -r /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
# Apple silicon
elif [ -r /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "[WARNING] A Homebrew installation was not found!"
fi

##################################################
# JAVA_HOME
##################################################
if [ -r /usr/libexec/java_home ]; then
  if [ -d "$(brew --prefix)/opt/openjdk" ]; then
    for dir in "$(brew --prefix)"/opt/openjdk@*; do
      JDKVERSION=$(echo "$dir" | grep -o '[[:digit:]]*')
      if [ ! -L /Library/Java/JavaVirtualMachines/openjdk-"${JDKVERSION}".jdk ] ; then
        echo "[INFO] Creating symlink: /Library/Java/JavaVirtualMachines/openjdk-${JDKVERSION}.jdk -> $(brew --prefix)/opt/openjdk@${JDKVERSION}/libexec/openjdk.jdk"
         sudo ln -sfn "$(brew --prefix)"/opt/openjdk@"${JDKVERSION}"/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-"${JDKVERSION}".jdk
      fi
    done;
    # Switch between different JDK versions using 'jdk 11', 'jdk 17', 'jdk 21' etc
    jdk() {
      version=$1
      unset JAVA_HOME
      PATH="$(brew --prefix)/opt/openjdk@$version/bin:$PATH"
      CPPFLAGS="-I$(brew --prefix)/opt/openjdk@$version/include"
      JAVA_HOME="$(/usr/libexec/java_home -v"$version")"
      export PATH
      export CPPFLAGS
      export JAVA_HOME
      java -version
    }
  fi
else
  echo "[WARNING] JAVA_HOME was not found!"
fi

##################################################
# GRADLE_USER_HOME
##################################################
export GRADLE_USER_HOME="$HOME/.gradle"

##################################################
# direnv -- Unclutter your .profile (https://github.com/direnv/direnv)
##################################################
if [[ $(command -v direnv) ]]; then
  eval "$(direnv hook bash)"
else
  echo "[WARNING] A direnv installation was not found!"
fi

##################################################
# Bash completion
##################################################
if [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
  # shellcheck disable=SC1091
  . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
else
  echo "[WARNING] A bash completion installation was not found!"
fi

##################################################
# Git completion
##################################################
if [[ -r "$HOME/.git-completion.bash" ]]; then
  # shellcheck disable=SC1091
  . "$HOME/.git-completion.bash"
else
  echo "[WARNING] A git completion installation was not found!"
fi

##################################################
# Amazon Command Line Interface Tools
##################################################
if [[ $(command -v aws_completer) ]]; then
  complete -C "$(command -v aws_completer)" aws
else
  echo "[WARNING] A aws completer installation was not found!"
fi

##################################################
# NVM
##################################################
if [[ -r "$(brew --prefix nvm)/nvm.sh" ]]; then
  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  . "$(brew --prefix nvm)/nvm.sh"  # This loads nvm
  # shellcheck disable=SC1091
  . "$(brew --prefix nvm)/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
else
  echo "[WARNING] A NVM installation was not found!"
fi

##################################################
# Starship
##################################################
if [[ $(command -v starship) ]]; then
  eval "$(starship init bash)"
else
  echo "[WARNING] A starship installation was not found!"
fi
