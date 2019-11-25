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
if [[ $(which brew) ]]; then
  eval $(`which brew` shellenv)
else
  echo "[WARNING] A Homebrew installation was not found!"
fi

##################################################
# JAVA_HOME
##################################################
if [ -r /usr/libexec/java_home ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  export JDK_HOME=$JAVA_HOME
else
  echo "[WARNING] JAVA_HOME was not found!"
fi

##################################################
# direnv -- Unclutter your .profile (https://github.com/direnv/direnv)
##################################################
if [[ $(which direnv) ]]; then
  eval "$(direnv hook bash)"
else
  echo "[WARNING] A direnv installation was not found!"
fi

##################################################
# Bash completion
##################################################
if [[ -r /usr/local/etc/bash_completion ]]; then
  source /usr/local/etc/bash_completion
else
  echo "[WARNING] A bash completion installation was not found!"
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
if [[ $(which aws_completer) ]]; then
  complete -C $(which aws_completer) aws
else
  echo "[WARNING] A aws completer installation was not found!"
fi

##################################################
# RVM
##################################################
# Load RVM into a shell session *as a function*
if [[ -r "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
else
  echo "[WARNING] An RVM installation was not found!"
fi

##################################################
# NVM
##################################################
if [[ -f "$(brew --prefix nvm)/nvm.sh" ]] ; then
  export NVM_DIR="$HOME/.nvm"
  mkdir -p "$NVM_DIR"
  source "$(brew --prefix nvm)/nvm.sh" # This loads nvm
  source "$(brew --prefix nvm)/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
else
  echo "[WARNING] An NVM installation was not found!"
fi

##################################################
# Conda setup
##################################################
if [ -r "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
  source "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
  alias ca="conda activate"
  alias cda="conda deactivate"
else
  echo "[WARNING] miniconda profile script not found!"
  echo "Run 'conda init' to initialize conda for shell interaction"
fi
