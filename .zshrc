# ~/.zshrc
#
# My interactive shell, in broad strokes:
#
#   Looks     starship prompt (psx to simplify it), vivid ls colours
#   Finds     fzf everywhere (Ctrl-R/O/T, Alt-C, **<tab>), zoxide for jumping
#   Plugins   sheldon (autosuggestions, syntax highlighting, fzf-tab), cached
#   Tools     homebrew, mise, direnv
#   Editing   vim mode with the emacs ctrl-keys I can't live without
#   History   effectively infinite, timestamped, per-session up-arrow
#   Helpers   take, rehash, psx, init-project
#
# Startup is kept fast: sheldon and brew shellenv are cached, compinit deferred.
#
# Package responsibilities: Homebrew owns the machine, mise owns the work.
# See DOTFILES.md.

echo work hard and be nice to people

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

# --------

# Homebrew
# First in the file: almost everything below (fzf, zoxide, sheldon, ...)
# lives in /opt/homebrew/bin and should resolve to brew's version.
# Cache brew shellenv for faster startup (regenerate if homebrew path changes)
BREW_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv.zsh"
if [[ ! -r "$BREW_CACHE" || /opt/homebrew/bin/brew -nt "$BREW_CACHE" ]]; then
  /opt/homebrew/bin/brew shellenv > "$BREW_CACHE"
fi
source "$BREW_CACHE"

# Path for interactive use. ~/.local/bin goes in front of everything,
# including homebrew.
# Set here rather than .zshenv or .zprofile:
#  - .zshenv runs before macOS's path_helper (/etc/zprofile), which would
#    reorder anything set there on login shells.
#  - .zprofile only runs for login shells, and Zellij panes aren't login
#    shells (see commit c0b810e).
# .zshrc is the only file that covers both Terminal tabs and Zellij panes.
typeset -U path  # dedupe PATH entries (keeps first occurrence)
export PATH=~/.local/bin:$PATH

# --------

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
eval "$(zoxide init zsh --cmd j)"

# mise
eval "$(mise activate zsh)"

# direnv
eval "$(direnv hook zsh)"

# starship for prompt
# generate config from base + themes if missing (starship.toml is gitignored)
if [[ ! -f ~/.config/starship/starship.toml ]]; then
  cat ~/.config/starship/config.toml ~/.config/starship/themes/*.toml \
    > ~/.config/starship/starship.toml
fi

eval "$(starship init zsh)"

# --------

# completion system
# Defer compinit to after shell startup for faster initial load
# Completions won't work until after first prompt, but shell appears instantly
# personal completions (land, rebase, ...)
fpath=(~/.config/zsh/completions $fpath)
autoload -Uz compinit
autoload -Uz add-zsh-hook
_deferred_compinit() {
  compinit -C  # -C skips security check
  # fzf-tab is sourced (by sheldon) before compinit runs, but wants to load
  # after it — re-enable now that the completion system exists.
  (( $+functions[enable-fzf-tab] )) && enable-fzf-tab
  # Remove this hook after first run
  add-zsh-hook -d precmd _deferred_compinit
}
add-zsh-hook precmd _deferred_compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive

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
unsetopt SHARE_HISTORY       # Keep other sessions' history out of up-arrow
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
reload() { source ~/.zshrc }

# Simple prompt for clean copy-paste. Usage: psx [label]
# Without a label, shows the current path. With a label, shows the label.
psx() {
  if [[ "$1" == "off" ]]; then
    eval "$(starship init zsh)"
    return
  fi
  precmd_functions=(${precmd_functions:#_starship_precmd})
  preexec_functions=(${preexec_functions:#_starship_preexec})
  if [[ -n "$1" ]]; then
    PROMPT="[$1]: \$ "
  else
    PROMPT='[%~]: $ '
  fi
}

# init-project: wraps the script so we cd into the new repo.
init-project() {
  local dir
  dir=$(command init-project "$@") || return
  cd "$dir"
}

# --------

# disable flow control and free up ctrl-s and ctrl-q
stty -ixon

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

# re-bind keys after vi mode did its thing.
# restore ctrl-f for autocompletion
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

# --------

# sheldon for plugins
# see ~/.config/sheldon/plugins.toml
# I'm using zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab.
#
# Loaded after the keybindings on purpose: zsh-syntax-highlighting wants to
# be sourced last, once all widgets and bindings exist.
#
# Cache sheldon output for faster startup
# Run 'sheldon lock --update' to regenerate after changing plugins.toml
SHELDON_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/sheldon/sheldon.zsh"
SHELDON_PLUGINS="${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/plugins.toml"
if [[ ! -r "$SHELDON_CACHE" || "$SHELDON_PLUGINS" -nt "$SHELDON_CACHE" ]]; then
  mkdir -p "$(dirname "$SHELDON_CACHE")"
  sheldon source > "$SHELDON_CACHE"
fi
source "$SHELDON_CACHE"

# zsh-autosuggestions:
# Ctrl-F: accept full suggestion
# Option-→: accept one word

# --------

# Aliases
source ~/.zshrc.aliases

# Nice ls colours using vivid.
VIVID_THEME="solarized-dark"
# Cache vivid output for faster startup (regenerates when vivid is updated)
VIVID_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/vivid-$VIVID_THEME"
if [[ ! -r "$VIVID_CACHE" || /opt/homebrew/bin/vivid -nt "$VIVID_CACHE" ]]; then
  vivid generate "$VIVID_THEME" > "$VIVID_CACHE"
fi
export LS_COLORS="$(<"$VIVID_CACHE")"

# --------

# Tab/window titles: "<command> — <dir>" while running, "<dir>" when idle.
# Makes Ghostty's Window menu list distinguishable when many tabs share a cwd.
_title_set() { printf '\e]2;%s\a' "$1" }
_title_dir() { print -P '%1~' }
_title_precmd() { _title_set "$(_title_dir)" }
_title_preexec() {
  local cmd=${2%% *}                     # first word of the expanded command
  [[ $cmd == (sudo|env|time|nohup) ]] && cmd=${${2#* }%% *}
  _title_set "$cmd — $(_title_dir)"
}
add-zsh-hook precmd _title_precmd
add-zsh-hook preexec _title_preexec


# Background tint per surface (window/tab/split) via OSC 11.
# Eight hues 45° apart in OKLCH, lightness matched to Gruvbox Dark Hard
# (#1d2021) so contrast stays ~12:1 and the gruvbox palette reads the same.
# Regenerate with ~/code/sandbox/scripts-by-claude/tint-palette.py.
# `tint` lists swatches; `tint <name|N|#hex>` pins this shell; `tint reset`
# returns to the directory-based default. Theme default = work.
typeset -ga TINT_ORDER=(red orange yellow green teal blue violet magenta)
typeset -gA TINTS=(
  red      '#301716'
  orange   '#2c1c08'
  yellow   '#1f220a'
  green    '#0c2519'
  teal     '#012528'
  blue     '#102132'
  violet   '#211b30'
  magenta  '#2c1825'
)
_tint_set() { printf '\e]11;%s\a' "$1" }
_tint_auto() {
  [[ $TERM_PROGRAM == ghostty && -z $TMUX && -z $_TINT_OVERRIDE ]] || return 0
  case $PWD in
    $HOME/code/fredrik(|/*))                          _tint_set $TINTS[blue] ;;
    $HOME/code/sandbox(|/*)|$HOME/code/upstream(|/*)) _tint_set $TINTS[green] ;;
    *)                                                printf '\e]111\a' ;;   # theme default (work)
  esac
}
tint() {
  local name hex i=0
  case "$1" in
    '')
      for name in $TINT_ORDER; do
        hex=$TINTS[$name]
        printf '%d  \e[48;2;%d;%d;%dm\e[38;2;235;219;178m %-8s \e[0m  %s\n' \
          $((++i)) 0x${hex[2,3]} 0x${hex[4,5]} 0x${hex[6,7]} $name $hex
      done ;;
    reset|auto) unset _TINT_OVERRIDE; _tint_auto ;;
    '#'*)       _TINT_OVERRIDE=1; _tint_set "$1" ;;
    <1-8>)      _TINT_OVERRIDE=1; _tint_set $TINTS[$TINT_ORDER[$1]] ;;
    *)          [[ -n $TINTS[$1] ]] || { print -u2 "tint: unknown tint '$1' (try: tint)"; return 1 }
                _TINT_OVERRIDE=1; _tint_set $TINTS[$1] ;;
  esac
}
add-zsh-hook chpwd _tint_auto
_tint_auto
