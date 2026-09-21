# Homebrew and PATH.
#
# First fragment on purpose: almost everything that follows (fzf, zoxide,
# sheldon, ...) lives in the brew prefix and should resolve to brew's version.

# Homebrew owns the machine, mise owns the work. See DOTFILES.md.
if [[ -x /opt/homebrew/bin/brew ]]; then
  BREW_BIN=/opt/homebrew/bin/brew
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  BREW_BIN=/home/linuxbrew/.linuxbrew/bin/brew
fi

if [[ -n $BREW_BIN ]]; then
  # Cache brew shellenv for faster startup; regenerate when brew itself changes.
  BREW_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv.zsh"
  if [[ ! -r "$BREW_CACHE" || "$BREW_BIN" -nt "$BREW_CACHE" ]]; then
    "$BREW_BIN" shellenv > "$BREW_CACHE"
  fi
  source "$BREW_CACHE"
fi

# ~/.local/bin goes in front of everything, including homebrew.
# Set here rather than .zshenv or .zprofile (see DOTFILES.md, Zsh Layout).
typeset -U path  # dedupe PATH entries (keeps first occurrence)
export PATH=~/.local/bin:$PATH
