# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

## Code Directory

All source code lives in `~/code/` with this structure:

| Path | Purpose | Remote |
|------|---------|--------|
| `knowit/{project}` | Work projects | `github.com/knowit-solutions-cocreate/{project}` |
| `fredrik/{project}` | Personal projects | `github.com/fredrik/{project}` |
| `sandbox/{project}` | Experiments, POC, scratch | Local (may graduate to `fredrik/`) |
| `others/{owner}/{project}` | Third-party code | `github.com/{owner}/{project}` |

When cloning, place repos according to this convention. See `~/code/CLAUDE.md` for details.

When Claude generates one-off scripts, put them in ~/code/sandbox/scripts-by-claude.


## Lima (Linux VMs)

Lima runs Linux VMs on macOS. A pre-configured devenv VM is available for running Nix/devenv in Linux.

**Files:**
- `~/.lima/_images/` - Baked VM images and yaml configs
- `~/.lima/_scripts/bootstrap-devenv/` - Scripts and documentation

**Quick start:**
```bash
~/.lima/_scripts/bootstrap-devenv/lima-devenv.sh
```

**Documentation:** `~/.lima/_scripts/bootstrap-devenv/lima-devenv-setup.md`
