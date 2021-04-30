# shellcheck shell=bash
# shellcheck disable=SC1090,SC1091

# Suppress macOS Catalina verbose message to use zsh as the default login shell
# https://support.apple.com/en-gb/HT208050
export BASH_SILENCE_DEPRECATION_WARNING=1

##################################################
# PATH
##################################################
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

##################################################
# Homebrew
##################################################
if test "$(uname -s)" = "Darwin"; then
  if [[ $(command -v brew) ]]; then
    eval "$($(command -v brew) shellenv)"
  else
    echo "[WARNING] A Homebrew installation was not found!"
  fi
elif test "$(uname -s)" = "Linux"; then
  if [ -r /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    echo "[WARNING] A Homebrew installation was not found!"
  fi
fi

##################################################
# JAVA_HOME
##################################################
if [ -r /usr/libexec/java_home ]; then
  JAVA_HOME="$(/usr/libexec/java_home)"
  export JAVA_HOME
  export JDK_HOME=$JAVA_HOME
elif [ -d "$(brew --prefix java11)/bin" ]; then
  PATH="$(brew --prefix java11)/bin:$PATH"
  export PATH
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
if test "$(uname -s)" = "Darwin"; then
  if [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
    else
      echo "[WARNING] A bash completion installation was not found!"
    fi
elif test "$(uname -s)" = "Linux"; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source "/usr/share/bash-completion/bash_completion"
  else
    echo "[WARNING] A bash completion installation was not found!"
  fi
fi

##################################################
# Git completion
##################################################
if [[ -r "$HOME/.git-completion.bash" ]]; then
  source "$HOME/.git-completion.bash"
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
# Conda setup
##################################################
if [ -d "$HOME/miniconda3/bin" ]; then
  # >>> conda initialize >>>
  # shellcheck disable=SC2016
  __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
  # shellcheck disable=SC2181
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
          . "$HOME/miniconda3/etc/profile.d/conda.sh"
      else
          export PATH="$HOME/miniconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
else
  echo "[WARNING] A conda installation was not found!"
fi

##################################################
# NVM
##################################################
if [[ -r "$(brew --prefix nvm)/nvm.sh" ]]; then
  export NVM_DIR="$HOME/.nvm"
  source "$(brew --prefix nvm)/nvm.sh"  # This loads nvm
  source "$(brew --prefix nvm)/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
else
  echo "[WARNING] A NVM installation was not found!"
fi
