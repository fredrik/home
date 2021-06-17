# inspiration for what zsh configuration should go where:
# https://unix.stackexchange.com/a/487889

echo work hard and be nice to people

# configure `ls`.
# list with colour (-G)
# and symbols that indicate type (-F)
alias ls='ls -FG'
# simple aliases.
# ('-o' omits group name from list)
alias ll='ls -lo'
alias lla='ls -loa'

# git shorties
alias a='git add'
alias b='git branch'
alias c='git commit'
alias cc='git commit -a'
alias d='git diff'
alias dd='git diff --cached'
alias ddd='git diff HEAD^ HEAD'
alias l='git log --stat --abbrev-commit'
alias s='git status'
alias t='git log --oneline --decorate --graph'

# load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

