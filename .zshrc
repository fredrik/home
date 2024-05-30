# ~/.zshrc @ vcc
#
# see also ~/.zshenv and ~/.zsh-alias

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

# z plugin
# https://github.com/agkozak/zsh-z
source ~/.zsh/zsh-z/zsh-z.plugin.zsh

# fzf + z = j
j() {
    [ $# -gt 0 ] && zshz "$*" && return
    cd "$(zshz -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# zsh-autosuggestions plugin
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# change the autosuggest colour to yellow. the default is not visible on dark solarized.
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'

# zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# pyenv shims etc
# https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv
eval "$(pyenv init -)"

source ~/.zsh-alias
