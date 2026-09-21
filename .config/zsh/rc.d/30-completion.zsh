# Completion system.
#
# compinit is deferred to the first prompt so the shell appears instantly;
# completions work from the second prompt on. fpath is set in .zshrc.
autoload -Uz compinit
autoload -Uz add-zsh-hook
_deferred_compinit() {
  compinit -C  # -C skips the security check
  # fzf-tab is sourced (by sheldon) before compinit runs, but wants to load
  # after it -- re-enable now that the completion system exists.
  (( $+functions[enable-fzf-tab] )) && enable-fzf-tab
  add-zsh-hook -d precmd _deferred_compinit  # run once
}
add-zsh-hook precmd _deferred_compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive

# fzf-tab previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:git-(checkout|switch|merge|rebase):*' fzf-preview \
    'git log --oneline --graph --color=always $word -- 2>/dev/null | head -20'
