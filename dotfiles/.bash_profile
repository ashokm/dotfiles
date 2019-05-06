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
# JAVA_HOME
##################################################
if [ -f /usr/libexec/java_home ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  export JDK_HOME=$JAVA_HOME
fi

##################################################
# direnv -- Unclutter your .profile (https://github.com/direnv/direnv)
##################################################
eval "$(direnv hook bash)"

##################################################
# Bash completion
##################################################
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

##################################################
# Git completion
##################################################
source ~/.git-completion.bash

##################################################
# Amazon Command Line Interface Tools
##################################################
complete -C '/usr/local/bin/aws_completer' aws

##################################################
# RVM
##################################################
# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then

  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"

elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then

  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"

else

  echo "[ERROR] An RVM installation was not found!"

fi

##################################################
# Conda setup
##################################################
if [ -r "/usr/local/miniconda3/etc/profile.d/conda.sh" ]; then
  source "/usr/local/miniconda3/etc/profile.d/conda.sh"
  alias ca="conda activate"
  alias cda="conda deactivate"
else
  echo "[INFO] miniconda profile script not found!"
fi
