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
