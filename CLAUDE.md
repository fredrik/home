# Dotfiles

Repository root: `~/`

## Key Files

- `.zshrc`, `.zshenv`, `.zshrc.aliases` - Shell config
- `.gitconfig`, `.gitignore-global`, `.config/git/ignore` - Git config
- `.config/brew/Brewfile` - Homebrew packages
- `.config/starship/` - Prompt (config.toml + themes/*.toml)
- `.config/vscode/` - VS Code settings
- `Justfile` - Task runner

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
