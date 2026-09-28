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
# directory-based default.
# Directory default: the nearest .tintrc from $PWD up to /, whose first word is
# anything `tint` accepts (e.g. `blue`, `3`, `#1d2021`, `default`). No .tintrc
# means the theme default (work). The file is only read, never sourced, and the
# value must resolve to a palette entry or #hex before it reaches the terminal.
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
# Helpers return through $REPLY so the chpwd path never forks.
# _tint_resolve <name|N|#hex|default|0> -> REPLY=#hex or "default"
_tint_resolve() {
  local x='[[:xdigit:]]'
  case "$1" in
    default|0) REPLY=default ;;
    <1-12>)    REPLY=$TINTS[$TINT_ORDER[$1]] ;;
    *)
      if [[ $1 == \#$~x$~x$~x(|$~x$~x$~x) ]]; then REPLY=$1
      elif [[ -n $1 && -n $TINTS[$1] ]];      then REPLY=$TINTS[$1]
      else REPLY=; return 1
      fi ;;
  esac
}
# _tint_find -> REPLY=path of the nearest .tintrc, or return 1
_tint_find() {
  local dir=$PWD
  while :; do
    [[ -f $dir/.tintrc && -r $dir/.tintrc ]] && { REPLY=$dir/.tintrc; return 0 }
    [[ $dir == / ]] && { REPLY=; return 1 }
    dir=${dir:h}
  done
}
# _tint_spec -> REPLY=#hex or "default" for $PWD
_tint_spec() {
  local rc word
  _tint_find || { REPLY=default; return 0 }
  rc=$REPLY
  read -r word _ < $rc
  _tint_resolve "$word" && return 0
  print -u2 "tint: $rc: unknown tint '${(V)word}' (try: tint)"
  REPLY=default
}
_tint_set() {
  if [[ $1 == default ]]; then printf '\e]111\a'
  else printf '\e]11;%s\a' "$1"
  fi
}
_tint_auto() {
  [[ $TERM_PROGRAM == ghostty && -z $TMUX && -z $_TINT_OVERRIDE ]] || return 0
  _tint_spec
  _tint_set $REPLY
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
      done
      if _tint_find; then print -r -- "here: ${REPLY/#$HOME/~}"; else print "here: no .tintrc"; fi
      [[ -n $_TINT_OVERRIDE ]] && print "pinned (tint reset to follow .tintrc)"
      ;;
    reset|auto) unset _TINT_OVERRIDE; _tint_auto ;;
    *)
      _tint_resolve "$1" || { print -u2 "tint: unknown tint '$1' (try: tint)"; return 1 }
      export _TINT_OVERRIDE=1; _tint_set $REPLY ;;
  esac
}
add-zsh-hook chpwd _tint_auto
_tint_auto
