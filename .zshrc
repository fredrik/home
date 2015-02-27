# hello,
# this is fredrik's ~/.zshrc
#
# direct any questions to fredrik@mollerstrand.se
# enjoy!


PROMPT='[%~]> ⚡  '

source ~/.functions
source ~/.aliases


# path
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin


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
