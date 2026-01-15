# CLAUDE.md

This is Fredrik's dotfiles repository, rooted at `~/`.

## Structure

Tracked configuration files:
- `.zshrc`, `.zshenv`, `.zprofile`, `.zshrc.aliases` - Zsh configuration
- `.gitconfig`, `.gitignore-global` - Git configuration
- `.config/mise/config.toml` - Mise (version manager for node, pnpm, etc.)
- `.config/sheldon/plugins.toml` - Sheldon (zsh plugin manager)
- `.config/starship.toml` - Starship prompt
- `.config/ghostty/config` - Ghostty terminal
- `.config/brew/Brewfile` - Homebrew packages
- `.config/uv/uv.toml` - uv (Python package manager)
- `.dotfiles/vscode/` - VS Code settings (symlinked)

## Shell Setup

The shell uses zsh with:
- Vim mode (with restored emacs-style ctrl bindings)
- Sheldon for plugins (zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab)
- Starship for the prompt
- fzf for fuzzy searching
- zoxide for directory jumping

## Conventions

- Configuration lives in `~/.config/` following XDG conventions where possible
- VS Code settings are in `.dotfiles/vscode/` and symlinked to the actual location
