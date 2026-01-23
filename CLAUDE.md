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

## Code Directory

All source code lives in `~/code/` with this structure:

| Path | Purpose | Remote |
|------|---------|--------|
| `knowit/{project}` | Work projects | `github.com/knowit-solutions-cocreate/{project}` |
| `fredrik/{project}` | Personal projects | `github.com/fredrik/{project}` |
| `sandbox/{project}` | Experiments, POC, scratch | Local (may graduate to `fredrik/`) |
| `others/{owner}/{project}` | Third-party code | `github.com/{owner}/{project}` |

When cloning, place repos according to this convention. See `~/code/CLAUDE.md` for details.
