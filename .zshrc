# hello,
# this is fredrik's ~/.zshrc
#
# direct any questions to fredrik@mollerstrand.se
# enjoy!

echo work hard and be nice to people
PROMPT='[%~]> ⚡  '

source ~/.functions
source ~/.aliases
source ~/.zsh-gpg


# TODO: paths in their own file

# path
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin


## bob used to use pure for a prompt.
#
# pure
# https://github.com/sindresorhus/pure
# (npm install --global pure-prompt)
#
## DISABLED
# autoload -U promptinit && promptinit
# PURE_PROMPT_SYMBOL=⚡
# PURE_CMD_MAX_EXEC_TIME=2
# prompt pure



# git completion.
autoload -U compinit && compinit

# comments are okay.
setopt interactivecomments


# ssh: bring in all keys.
ssh-add ~/.ssh/id_[rd]sa &> /dev/null


# aws auths
if [[ -f ~/.aws ]]; then
  source ~/.aws
fi


# this is python specific and worse.
# TODO: make not python specific.
workwork() {
  project=$1
  if [[ -z $project ]]; then echo "work on what, sire?"; return; fi
  if [[ ! -d ~/hack/${project} ]]; then echo "don't know that one, sire."; return; fi
  cd ~/hack/${project} && workon $project
  export PYTHONPATH=~/hack/${project}:$PYTHONPATH
  if [[ -f ~/hack/.${project}.rc ]]; then source ~/hack/.${project}.rc; fi
}
alias ww=workwork

# default editor
export EDITOR=vim


## stuff from bob
#
## rbenv
# eval "$(rbenv init -)"
#
## go
# export GOPATH=/usr/local/go
# export PATH=$PATH:/usr/local/go/bin
