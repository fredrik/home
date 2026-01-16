# CLAUDE.md

This is Fredrik's dotfiles repository, rooted at `~/`.

## Structure

Tracked configuration files:
- `.zshrc`, `.zshenv`, `.zshrc.aliases` - Zsh configuration
- `.gitconfig`, `.gitignore-global`, `.config/git/ignore` - Git configuration
- `.config/mise/config.toml` - Mise (version manager for node, pnpm, etc.)
- `.config/sheldon/plugins.toml` - Sheldon (zsh plugin manager)
- `.config/starship/` - Starship prompt (config and themes)
- `.config/ghostty/config` - Ghostty terminal
- `.config/zellij/config.kdl` - Zellij terminal multiplexer
- `.config/brew/Brewfile` - Homebrew packages
- `.config/uv/uv.toml` - uv (Python package manager)
- `.config/vscode/` - VS Code settings (symlinked to ~/Library/Application Support/Code/User/)
- `.claude/` - Claude Code configuration

## Shell Setup

The shell uses zsh with:
- Vim mode (with restored emacs-style ctrl bindings)
- Sheldon for plugins (zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab)
- Starship for the prompt
- fzf for fuzzy searching
- zoxide for directory jumping

## Starship Prompt

Starship configuration uses a custom theme system:
- `config.toml` - Base prompt configuration with `palette = 'theme_name'` setting
- `themes/*.toml` - Palette definitions (catppuccin, gruvbox variants)
- `starship.toml` - Generated output (concatenation of config + themes)

The `starship-theme` function in `.zshrc.aliases` switches themes:
- `starship-theme` - Show current theme and available palettes
- `starship-theme <palette>` - Switch to a palette (e.g., `starship-theme gruvbox_dark`)

When changing themes, edit `config.toml` and run `starship-theme <palette>` to regenerate `starship.toml`.

## Conventions

- Configuration lives in `~/.config/` following XDG conventions where possible
- VS Code settings are symlinked from `~/.config/vscode/` to `~/Library/Application Support/Code/User/`
- When adding or removing tracked files, update this CLAUDE.md to reflect the changes
