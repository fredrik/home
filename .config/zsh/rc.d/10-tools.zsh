# Shell integrations for everyday tools. Each block is skipped when the tool
# is not installed.

# fzf for fuzzy searching
#   Ctrl-T: fuzzy file picker, inserts path
#   Alt-C:  fuzzy cd into directory
#   **<tab> completion: vim **<tab>, cd **<tab>, ssh **<tab>
# (fzf also binds Ctrl-R, but atuin takes it over below. Ctrl-O keeps fzf
# history search, select and execute, over ~/.zsh_history; 50-keybindings.zsh.)
(( $+commands[fzf] )) && source <(fzf --zsh)

# Ctrl-T/Alt-C list files with fd rather than fzf's own walker, skipping
# caches and app data (from ~ the walker finds ~3M entries, mostly Library/,
# .cache/ and .venv/). --no-ignore-vcs because ~/.gitignore (dotfiles repo)
# ignores almost everything, which would hide code/, .irssi/ and friends.
if (( $+commands[fzf] && $+commands[fd] )); then
  _fzf_fd_opts=(--hidden --follow --no-ignore-vcs
    --exclude .git --exclude node_modules --exclude .venv
    --exclude Library --exclude Mail --exclude .Trash
    --exclude .cache --exclude .local/share --exclude .cargo/registry
    --exclude .npm --exclude .codex/.tmp --exclude .azure/cliextensions
    --exclude .kube/cache)
  export FZF_CTRL_T_COMMAND="fd ${_fzf_fd_opts[*]}"
  export FZF_ALT_C_COMMAND="fd --type d ${_fzf_fd_opts[*]}"
  unset _fzf_fd_opts
fi

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
