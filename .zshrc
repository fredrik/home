# ~/.zshrc @ vcc
#
# see also ~/.zshenv

autoload -U compinit
compinit -d ~/.cache/zcompdump

# zsh
setopt share_history
setopt hist_ignore_space
setopt extended_history

# p10k
source ~/.p10k.init.zsh

# fzf
eval "$(fzf --zsh)"

# fzf-tab plugin
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

# zsh-autosuggestions plugin
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# change the autosuggest colour to yellow. the default is not visible on dark solarized.
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'


# pyenv shims etc
# https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv
eval "$(pyenv init -)"

