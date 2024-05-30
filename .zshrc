# ~/.zshrc @ vcc
#
# see also ~/.zshenv


# p10k
source ~/.p10k.init.zsh

# fzf
eval "$(fzf --zsh)"

# pyenv shims etc
# https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv
eval "$(pyenv init -)"

# zsh
setopt share_history
setopt hist_ignore_space
setopt extended_history
