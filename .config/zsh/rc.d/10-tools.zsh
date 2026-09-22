# Shell integrations for everyday tools. Each block is skipped when the tool
# is not installed.

# fzf for fuzzy searching
#   Ctrl-T: fuzzy file picker, inserts path
#   Alt-C:  fuzzy cd into directory
#   **<tab> completion: vim **<tab>, cd **<tab>, ssh **<tab>
# (fzf also binds Ctrl-R, but atuin takes it over below. Ctrl-O keeps fzf
# history search, select and execute, over ~/.zsh_history; 50-keybindings.zsh.)
(( $+commands[fzf] )) && source <(fzf --zsh)

# atuin for shell history. Config in ~/.config/atuin/config.toml, local only.
#   Ctrl-R: search all sessions; Enter runs, Tab inserts for editing,
#           Ctrl-R again cycles filter (global / directory / session)
# Must come after fzf so atuin's Ctrl-R wins. Up-arrow is left to zsh so it
# stays per-session (40-options.zsh).
(( $+commands[atuin] )) && eval "$(atuin init zsh --disable-up-arrow)"

# zoxide for directory jumping (as `j`)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd j)"

# mise: project-pinned tool versions
(( $+commands[mise] )) && eval "$(mise activate zsh)"

# direnv
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
