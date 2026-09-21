# Line editing: vim mode with the emacs ctrl-keys I can't live without.
#
# Sheldon (60-plugins.zsh) loads after this on purpose: zsh-syntax-highlighting
# wants to be sourced last, once all widgets and bindings exist.

# disable flow control and free up ctrl-s and ctrl-q
[[ -t 0 ]] && stty -ixon

# 'bindkey -v' must be the first bindkey call.
bindkey -v
KEYTIMEOUT=1
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^Y' yank
bindkey '^Q' kill-word
bindkey '^W' backward-kill-word
bindkey '^D' delete-char

# zsh-autosuggestions: Ctrl-F accepts the full suggestion, Option-Right one word.
# (the widget appears once sheldon has loaded the plugin)
bindkey '^F' autosuggest-accept

# edit command line with Ctrl-X Ctrl-E
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# fzf history: Ctrl-O to select and execute immediately
fzf-history-execute() {
  zle fzf-history-widget
  if [[ $? -eq 0 && -n "$BUFFER" ]]; then
    zle accept-line
  fi
}
zle -N fzf-history-execute
bindkey '^O' fzf-history-execute

# Option+Left/Right for word movement, Option+Backspace to delete word
bindkey '^[b' backward-word
bindkey '^[f' forward-word
bindkey '^[^?' backward-kill-word
