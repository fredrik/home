# hello,
# this is fredrik's ~/.zshrc
#
# direct any questions to fredrik@mollerstrand.se
# enjoy!

echo work hard and be nice to people

autoload -U promptinit && promptinit
prompt walters

# legacy prompt:
# PROMPT='[%~]> ⚡  '

source ~/.functions
source ~/.aliases
source ~/.zsh-gpg
source ~/.zsh-python
source ~/.zsh-ruby
source ~/.zsh-go


HISTSIZE=1000000

# TODO: paths in their own file

# path
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:~/.rbenv/bin

# git completion.
autoload -U compinit && compinit

# comments are okay.
setopt interactivecomments

# default editor
export EDITOR=vim

# ssh: bring in all keys.
ssh-add ~/.ssh/id_[rd]sa* &> /dev/null
