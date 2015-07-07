
echo work hard and be nice to people

# pure
# https://github.com/sindresorhus/pure
# (npm install --global pure-prompt)
autoload -U promptinit && promptinit
PURE_PROMPT_SYMBOL=⚡
PURE_CMD_MAX_EXEC_TIME=2
prompt pure

# legacy prompt:
# PROMPT='[%~]> ⚡  '


# git completion.
autoload -U compinit && compinit

source ~/.aliases
source ~/.zsh-gpg


# default editor
export EDITOR=vim

# history
HISTSIZE=10000
SAVEHIST=0

# add local sbin to $PATH
export PATH=$PATH:/usr/local/sbin

# rbenv
eval "$(rbenv init -)"

# go
export GOPATH=/usr/local/go
export PATH=$PATH:/usr/local/go/bin


rehash() {
    # reload all the configuration.
    source ~/.zshrc
}
