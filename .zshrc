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

ZSH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Autoloaded helper functions (one file per function) and personal completions.
fpath=($ZSH_CONFIG/functions $ZSH_CONFIG/completions $fpath)
autoload -Uz $ZSH_CONFIG/functions/*(.N:t)

# Numbered fragments; the number encodes load order. See DOTFILES.md.
for _f in $ZSH_CONFIG/rc.d/*.zsh(N); do source $_f; done; unset _f

# Machine-specific overrides, not tracked.
[[ -r $ZSH_CONFIG/local.zsh ]] && source $ZSH_CONFIG/local.zsh

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
# Six hues picked for perceptual separation (not even spacing), each at 78% of
# its OWN chroma ceiling in OKLCH -- a flat chroma is capped by cyan and leaves
# red/blue/magenta washed out. Yellow gets lightness instead of chroma, which it
# cannot hold here. The `*max` twins push to 95% for surfaces that must shout.
# Lightness tracks Gruvbox Dark Hard (#1d2021) so contrast stays ~11:1 and the
# gruvbox palette reads the same.
# Regenerate with ~/code/sandbox/scripts-by-claude/tint-palette.py.
# `tint` lists swatches; `tint <name|N|#hex>` pins this surface; `tint default`
# (or 0) pins the untinted theme background; `tint reset` returns to the
# directory-based default. Theme default = work.
# The pin is exported so a nested or exec'd shell inherits it and leaves the
# surface alone -- background colour belongs to the surface, not the process.
typeset -ga TINT_ORDER=(
  red yellow green cyan blue magenta
  redmax yellowmax greenmax cyanmax bluemax magentamax
)
typeset -gA TINTS=(
  red        '#3d0a0b'
  yellow     '#2d260a'
  green      '#08270b'
  cyan       '#082427'
  blue       '#031947'
  magenta    '#350a33'
  redmax     '#420105'
  yellowmax  '#2f2601'
  greenmax   '#012805'
  cyanmax    '#012529'
  bluemax    '#001550'
  magentamax '#390137'
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
      printf '%-2d \e[48;2;29;32;33m\e[38;2;235;219;178m %-10s \e[0m  %s\n' 0 default '(theme)'
      for name in $TINT_ORDER; do
        hex=$TINTS[$name]
        printf '%-2d \e[48;2;%d;%d;%dm\e[38;2;235;219;178m %-10s \e[0m  %s\n' \
          $((++i)) 0x${hex[2,3]} 0x${hex[4,5]} 0x${hex[6,7]} $name $hex
      done ;;
    reset|auto) unset _TINT_OVERRIDE; _tint_auto ;;
    default|0)  export _TINT_OVERRIDE=1; printf '\e]111\a' ;;   # pin theme default
    '#'*)       export _TINT_OVERRIDE=1; _tint_set "$1" ;;
    <1-12>)     export _TINT_OVERRIDE=1; _tint_set $TINTS[$TINT_ORDER[$1]] ;;
    *)          [[ -n $TINTS[$1] ]] || { print -u2 "tint: unknown tint '$1' (try: tint)"; return 1 }
                export _TINT_OVERRIDE=1; _tint_set $TINTS[$1] ;;
  esac
}
add-zsh-hook chpwd _tint_auto
_tint_auto
