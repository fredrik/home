# starship prompt. `psx` (functions/) swaps in a plain prompt for copy-paste.
(( $+commands[starship] )) || return 0

# starship.toml is gitignored; generate it from base config + themes if missing.
# `starship-theme` regenerates it when switching palettes.
if [[ ! -f ~/.config/starship/starship.toml ]]; then
  cat ~/.config/starship/config.toml ~/.config/starship/themes/*.toml \
    > ~/.config/starship/starship.toml
fi

eval "$(starship init zsh)"
