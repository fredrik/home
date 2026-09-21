# Nice ls colours using vivid.
(( $+commands[vivid] )) || return 0

VIVID_THEME="solarized-dark"
# Cache vivid output for faster startup; regenerates when vivid is updated.
VIVID_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/vivid-$VIVID_THEME"
if [[ ! -r "$VIVID_CACHE" || "${commands[vivid]:A}" -nt "$VIVID_CACHE" ]]; then
  vivid generate "$VIVID_THEME" > "$VIVID_CACHE"
fi
export LS_COLORS="$(<"$VIVID_CACHE")"
