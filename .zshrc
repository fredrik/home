PROMPT='[%~]> '

export PATH=/usr/local/share/python:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin


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



workwork() {
  project=$1
  if [[ -z $project ]]; then echo "work on what, sire?"; return; fi
  if [[ ! -d ~/hack/${project} ]]; then echo "don't know that one, sire."; return; fi
  cd ~/hack/${project} && workon $project
  export PYTHONPATH=~/hack/${project}:$PYTHONPATH
  if [[ -f ~/hack/.${project}.rc ]]; then source ~/hack/.${project}.rc; fi
}
alias ww=workwork

# comments are okay.
setopt interactivecomments


rehash() {
    # reload all the configuration.
    source ~/.zshrc
}
