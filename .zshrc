# hello!
# this is fredrik's ~/.zshrc
# please enjoy and direct any questions and answers to fredrik@mollerstrand.se



autoload -U promptinit && promptinit
prompt bigfade

# old prompt:
# PROMPT='[%~]> ⚡  '


# history
HISTSIZE=10000 # session history size
SAVEHIST=1000 # saved history

# git completion.
autoload -U compinit && compinit

source ~/.aliases

if [[ -f /usr/local/share/python/virtualenvwrapper.sh ]]; then
  source /usr/local/share/python/virtualenvwrapper.sh
fi

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python


# aws auths
if [[ -f ~/.aws ]]; then
  source ~/.aws
fi


# path
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
export PATH=$PATH:~/bin


workwork() {
  project=$1
  if [[ -z $project ]]; then echo "work on what, sire?"; return; fi
  if [[ ! -d ~/hack/${project} ]]; then echo "don't know that one, sire."; return; fi
  cd ~/hack/${project} && workon $project
  export PYTHONPATH=~/hack/${project}:$PYTHONPATH
  if [[ -f ~/hack/.${project}.rc ]]; then source ~/hack/.${project}.rc; fi
}
alias ww=workwork


# py.test
function watchpytest {
  echo "running tests ($*) on changes."
  watchmedo shell-command -w -p '*.py' -R -c "py.test $*"
}
alias wpt=watchpytest

# comments are okay.
setopt interactivecomments


rehash() {
    # reload all the configuration.
    source ~/.zshrc
}
