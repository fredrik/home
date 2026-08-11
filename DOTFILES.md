# Dotfiles

## Overview

Dotfiles repository. Root: `~/`

## Key Files

- `.zshrc`, `.zshenv`, `.zshrc.aliases` - Shell config
- `.gitconfig`, `.config/git/ignore` - Git config (global excludesfile)
- `.config/brew/Brewfile` - Homebrew packages
- `.config/mise/config.toml` - Dev tool version manager
- `.config/starship/` - Prompt (config.toml + themes/*.toml)
- `.config/ghostty/config` - Ghostty terminal
- `.config/zed/settings.json` - Zed editor
- `.config/vscode/` - VS Code settings
- `.config/nvim/` - Neovim config
- `.config/lazygit/config.yml` - lazygit
- `.config/zellij/config.kdl` - Zellij multiplexer
- `.config/pomo/pomo.yaml` - Pomodoro timer
- `Justfile` - Task runner
- `.local/bin/wakeup` - Podman VM time sync on wake

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

## Homebrew vs mise

- **Homebrew owns the machine.** Everything that must exist outside a project
  or outside an interactive shell: the shell stack (fzf, zoxide, sheldon,
  starship, zellij, neovim, ...), daemons and services (syncthing,
  sleepwatcher, postgresql, colima), GUI casks, libraries, system utilities.
  Also mise itself.
- **mise owns the work.** Anything a project pins because the version must
  match something — a cluster, CI, a teammate. Runtimes (node, python) and
  project CLI belts, declared in the repo's `mise.toml`.

The technical reason for the split: `mise activate` only runs in `.zshrc`, so
mise tools exist only at the interactive prompt. Scripts, cron, and launchd
see Homebrew (via `/etc/paths.d/homebrew`) but never mise. Anything needed by
automation must therefore be brew.

A tool may exist in both: brew provides the global ad-hoc fallback, and mise
shadows it with a pinned version inside project directories. That shadowing is
the system working as designed. The question to ask per tool: "do I run this
outside a pinning project?"

- Kept in brew as global fallbacks: az, k9s, yq, just, uv, helm.
- Removed from brew 2026-08-11, now mise-only: kubeseal, kubeconform,
  kustomize, hugo, pulumi. Projects that need these must pin them in their
  `mise.toml` (e.g. local-dev-blog pins hugo).

`~/code/knowit/fluxcd-dataplatform`'s `.mise.toml` is the textbook example:
exact pins matched to cluster versions, with comments. `mise prune` removes
installed versions no config references.

## Sleepwatcher

`sleepwatcher` (via Homebrew) runs `~/.local/bin/wakeup` on macOS wake to sync the Podman VM clock. The Podman VM drifts during sleep since the `applehv` VM clock stops while suspended. Without this, Claude Code's OAuth token validation fails inside containers due to clock skew.

- Script: `~/.local/bin/wakeup` — sets VM time from host via `podman machine ssh`
- Plist: `~/Library/LaunchAgents/homebrew.mxcl.sleepwatcher.plist` (custom copy, not managed by `brew services`)
- Log: `~/.local/log/wakeup.log`
- Do NOT use `brew services start sleepwatcher` — the user LaunchAgent manages it

## Starship Themes

Theme switching uses `starship-theme` function in `.zshrc.aliases`:

- Base config: `.config/starship/config.toml` (set `palette = 'name'`)
- Palettes: `.config/starship/themes/*.toml`
- Output: `.config/starship/starship.toml` (gitignored, regenerated on shell start)
