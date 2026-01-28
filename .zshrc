# ~/.zshrc
echo work hard and be nice to people

# ========================================
# Performance optimizations
# ========================================
# This config uses several techniques to minimize startup time:
#
# 1. Cached eval outputs (sheldon, brew) - regenerated automatically when config changes
# 2. Deferred compinit - loads completions after first prompt appears
# 3. compinit -C - skips security check (run 'compinit' manually if fpath changes)
#
# Additional optimization (not enabled):
# - mise: use 'mise activate zsh --shims' instead for faster startup (~25ms saved)
#   Trade-off: no automatic version switching when cd'ing between projects
#
# To measure startup time: time zsh -i -c exit
# To profile: add 'zmodload zsh/zprof' at top and 'zprof' at bottom
# ========================================

#
# Here's the sourcing order for zsh configurations:
#   Login interactive:     .zshenv → .zprofile → .zshrc → .zlogin (→ .zlogout)
#   Non-login interactive: .zshenv → .zshrc
#   Non-interactive:       .zshenv
#
# .zshenv  = always, all shells (PATH, env vars needed by scripts)
# .zprofile = login only, before .zshrc (env setup)
# .zshrc   = interactive (prompt, aliases, keybindings, completions)
# .zlogin  = login only, after .zshrc (rarely used)
#
# Login: first shell of session
# Non-login: child shell (new tab, `zsh`, tmux pane)
# Interactive = human at prompt
# Non-interactive = scripts, cron, `zsh -c "..."`
#


# fzf for fuzzy searching
source <(fzf --zsh)
# fzf keybindings:
# Ctrl-R: fuzzy history search
# Ctrl-O: fuzzy history search + execute immediately
# Ctrl-T: fuzzy file picker, inserts path
# Alt-C: fuzzy cd into directory
# fzf completion (trigger with **<tab>):
# vim **<tab>: fuzzy file search
# cd **<tab>: fuzzy directory search
# ssh **<tab>: fuzzy host completion
# zoxide for directory jumping
eval "$(zoxide init zsh)"

# sheldon for plugins
# Cache sheldon output for faster startup
# Run 'sheldon lock --update' to regenerate after changing plugins.toml
SHELDON_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/sheldon/sheldon.zsh"
if [[ ! -r "$SHELDON_CACHE" || "${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/plugins.toml" -nt "$SHELDON_CACHE" ]]; then
  mkdir -p "$(dirname "$SHELDON_CACHE")"
  sheldon source > "$SHELDON_CACHE"
fi
source "$SHELDON_CACHE"
# see ~/.config/sheldon/plugins.toml
# I'm using zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab.
#
# zsh-autosuggestions:
# Ctrl-F: accept full suggestion
# Option-→: accept one word

# Homebrew
# Cache brew shellenv for faster startup (regenerate if homebrew path changes)
BREW_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv.zsh"
if [[ ! -r "$BREW_CACHE" || /opt/homebrew/bin/brew -nt "$BREW_CACHE" ]]; then
  /opt/homebrew/bin/brew shellenv > "$BREW_CACHE"
fi
source "$BREW_CACHE"

# Mise
eval "$(mise activate zsh)"

# starship for prompt
# generate config from base + themes if missing (starship.toml is gitignored)
[[ -f ~/.config/starship/starship.toml ]] || cat ~/.config/starship/config.toml ~/.config/starship/themes/*.toml > ~/.config/starship/starship.toml

# should go last
eval "$(starship init zsh)"

# --------

# completion system
# Defer compinit to after shell startup for faster initial load
# Completions won't work until after first prompt, but shell appears instantly
autoload -Uz compinit
_deferred_compinit() {
  compinit -C  # -C skips security check
  # Remove this hook after first run
  add-zsh-hook -d precmd _deferred_compinit
}
add-zsh-hook precmd _deferred_compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case-insensitive

# fzf-preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:git-(checkout|switch|merge|rebase):*' fzf-preview \
    'git log --oneline --graph --color=always $word -- 2>/dev/null | head -20'

# --------

# history forever
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt EXTENDED_HISTORY      # Timestamp entries
unsetopt SHARE_HISTORY       # Don't import other sessions' history (up arrow doesn't include other sessions' history)
setopt INC_APPEND_HISTORY    # Write immediately (global search works)
setopt HIST_IGNORE_DUPS      # Skip consecutive duplicates
setopt HIST_VERIFY           # Show before executing from history

# comments are welcome.
setopt INTERACTIVE_COMMENTS

# directory handling with stacks etc
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS


# --------

# Change into newly created directory.
take() { mkdir -p "$1" && cd "$1" }

# reload this configuration.
rehash() { source ~/.zshrc }

# disable flow control and free up ctrl-s and ctrl-q
stty -ixon

# edit command line with Ctrl-X Ctrl-E
autoload -Uz edit-command-line
zle -N edit-command-line



# use vim mode, but restore the essential emacs-like ctrl-based commands.
# note that 'bindkey -v' needs to be the first bindkey call.
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

# re-bind keys after vi mode did it's thing.
# restore ctrl-f for autocompletion
bindkey '^F' autosuggest-accept
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

# --------

# Path for interactive use.
export PATH=~/.local/bin:$PATH

# Aliases
source ~/.zshrc.aliases

# nice ls colours
export LS_COLORS="$(vivid generate solarized-dark)"
