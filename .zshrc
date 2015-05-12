PROMPT='[%~]> ⚡  '

echo work hard and be nice to people

# git completion.
autoload -U compinit && compinit

source ~/.aliases
source ~/.zsh-gpg

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
