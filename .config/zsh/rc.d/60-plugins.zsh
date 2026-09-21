# Plugins via sheldon: zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab,
# dotenv. See ~/.config/sheldon/plugins.toml.
#
# Loaded after the keybindings on purpose (syntax highlighting wants to be
# last) and before compinit fires (fzf-tab is re-enabled in 30-completion.zsh).
(( $+commands[sheldon] )) || return 0

# Cache sheldon output for faster startup; regenerates when plugins.toml changes.
# Run 'sheldon lock --update' to update the plugins themselves.
SHELDON_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/sheldon/sheldon.zsh"
SHELDON_PLUGINS="${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/plugins.toml"
if [[ ! -r "$SHELDON_CACHE" || "$SHELDON_PLUGINS" -nt "$SHELDON_CACHE" ]]; then
  mkdir -p "$(dirname "$SHELDON_CACHE")"
  sheldon source > "$SHELDON_CACHE"
fi
source "$SHELDON_CACHE"
