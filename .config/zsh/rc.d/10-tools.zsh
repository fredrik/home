# Shell integrations for everyday tools. Each block is skipped when the tool
# is not installed.

# fzf for fuzzy searching
#   Ctrl-R: fuzzy history search
#   Ctrl-T: fuzzy file picker, inserts path
#   Alt-C:  fuzzy cd into directory
#   **<tab> completion: vim **<tab>, cd **<tab>, ssh **<tab>
# (Ctrl-O, select and execute, is bound in 50-keybindings.zsh.)
(( $+commands[fzf] )) && source <(fzf --zsh)

# zoxide for directory jumping (as `j`)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd j)"

# mise: project-pinned tool versions
(( $+commands[mise] )) && eval "$(mise activate zsh)"

# direnv
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
