# Dotfiles

## Overview

Dotfiles repository. Root: `~/`

## Key Files

- `.zshrc`, `.zshenv`, `.zshrc.aliases` - Shell config
- `.gitconfig`, `.gitignore-global`, `.config/git/ignore` - Git config
- `.config/brew/Brewfile` - Homebrew packages
- `.config/starship/` - Prompt (config.toml + themes/*.toml)
- `.config/vscode/` - VS Code settings
- `Justfile` - Task runner

## Commands

```bash
just brew-dump      # Dump Homebrew packages to Brewfile
just brew-install   # Install from Brewfile
just starship-build # Regenerate starship.toml from config + themes
just vscode-link    # Symlink VS Code settings
```

## Instructions

- Follow XDG conventions: config goes in `~/.config/`
- VS Code settings symlink from `~/.config/vscode/` to `~/Library/Application Support/Code/User/`
- After adding/removing tracked files, update this file
- Run `just brew-dump` after modifying Brewfile dependencies

## Starship Themes

Theme switching uses `starship-theme` function in `.zshrc.aliases`:
- Base config: `.config/starship/config.toml` (set `palette = 'name'`)
- Palettes: `.config/starship/themes/*.toml`
- Output: `.config/starship/starship.toml` (gitignored, regenerated on shell start)
