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
alias d='git diff'
alias s='git status'

