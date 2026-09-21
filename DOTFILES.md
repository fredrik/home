# Dotfiles

## Overview

Dotfiles repository. Root: `~/`

## Key Files

- `.zshrc`, `.zshenv`, `.config/zsh/` - Shell config (see Zsh Layout)
- `.config/sheldon/plugins.toml` - Zsh plugins (autosuggestions, syntax highlighting, fzf-tab, dotenv)
- `.gitconfig`, `.config/git/ignore` - Git config (global excludesfile)
- `.config/brew/Brewfile` - Homebrew packages
- `.config/mise/config.toml` - Dev tool version manager
- `.config/starship/` - Prompt (config.toml + themes/*.toml)
- `.config/atuin/config.toml` - Shell history (local only, no sync)
- `.config/ghostty/config` - Ghostty terminal
- `.config/zed/settings.json` - Zed editor
- `.config/nvim/` - Neovim config
- `.config/lazygit/config.yml` - lazygit
- `.config/zellij/config.kdl` - Zellij multiplexer
- `.config/tmux/tmux.conf` - tmux multiplexer
- `.config/pomo/pomo.yaml` - Pomodoro timer
- `.local/bin/wakeup` - Podman VM time sync on wake

## Zsh Layout

Sourcing order, for reference:

```
Login interactive:     .zshenv -> .zprofile -> .zshrc -> .zlogin (-> .zlogout)
Non-login interactive: .zshenv -> .zshrc
Non-interactive:       .zshenv
```

- `.zshenv` = always, all shells (env vars needed by scripts)
- `.zprofile` = login only, before `.zshrc` (unused; Zellij/tmux panes are not login shells)
- `.zshrc` = interactive (prompt, aliases, keybindings, completions)

`.zshrc` is a thin loader. The content lives in `~/.config/zsh/`:

- `rc.d/NN-topic.zsh` - sourced in numeric order. Each fragment guards on its
  tool (`(( $+commands[fzf] )) || return`) so the same files work on a machine
  that lacks it. The numbers encode real ordering constraints:

  | File | Contents | Must come... |
  |------|----------|--------------|
  | `00-brew.zsh` | brew shellenv (cached), `~/.local/bin` first in PATH | first, so later tools resolve to brew's binaries |
  | `10-tools.zsh` | fzf, atuin (Ctrl-R), zoxide (`j`), mise, direnv | after PATH; atuin after fzf so it owns Ctrl-R |
  | `20-prompt.zsh` | starship, regenerates `starship.toml` if missing | |
  | `30-completion.zsh` | deferred compinit, zstyles, fzf-tab previews | |
  | `40-options.zsh` | history, setopts | |
  | `50-keybindings.zsh` | `bindkey -v` plus emacs ctrl-keys, Ctrl-O, Ctrl-X Ctrl-E | `bindkey -v` before every other binding |
  | `60-plugins.zsh` | sheldon (cached) | after all bindings: syntax highlighting must be sourced last |
  | `70-aliases.zsh` | eza, bat, git shorties, local tools | |
  | `80-colors.zsh` | `LS_COLORS` from vivid (cached) | |
  | `90-title.zsh` | tab/window titles via OSC 2 | |
  | `95-tint.zsh` | per-surface background tint via OSC 11, `tint` command | |

- `functions/` - one autoloaded function per file: `take`, `reload`, `psx`,
  `init-project`, `starship-theme`, `httpstatus`.
- `completions/` - personal completion functions (gitignored).
- `local.zsh` - machine-specific overrides, sourced last, gitignored.

Startup caches live in `~/.cache/`: `brew-shellenv.zsh`, `sheldon/sheldon.zsh`
and `vivid-<theme>`. Each regenerates when its source (the brew binary,
`plugins.toml`, the vivid binary) is newer; delete the file to force it.
`reload` re-sources `.zshrc`.

PATH for interactive use is set in `rc.d`, not `.zshenv` or `.zprofile`:
`.zshenv` runs before macOS's `path_helper` (`/etc/zprofile`) which would
reorder it on login shells, and `.zprofile` never runs for multiplexer panes.

## Commands

Autoloaded zsh functions from `.config/zsh/functions/`:

```bash
brew-dump       # Dump Homebrew packages to Brewfile
brew-install    # Install from Brewfile
starship-build  # Regenerate starship.toml from config + themes
```

## Instructions

- Follow XDG conventions: config goes in `~/.config/`
- After adding/removing tracked files, update this file
- Run `brew-dump` after modifying Brewfile dependencies

## Homebrew vs mise

- **Homebrew owns the machine.** Everything that must exist outside a project
  or outside an interactive shell: the shell stack (fzf, atuin, zoxide, sheldon,
  starship, zellij, neovim, ...), daemons and services (syncthing,
  sleepwatcher, postgresql, colima), GUI casks, libraries, system utilities.
  Also mise itself.
- **mise owns the work.** Anything a project pins because the version must
  match something — a cluster, CI, a teammate. Runtimes (node, python) and
  project CLI belts, declared in the repo's `mise.toml`.

The technical reason for the split: `mise activate` only runs for interactive
shells (`.config/zsh/rc.d/10-tools.zsh`), so
mise tools exist only at the interactive prompt. Scripts, cron, and launchd
see Homebrew (via `/etc/paths.d/homebrew`) but never mise. Anything needed by
automation must therefore be brew.

A tool may exist in both: brew provides the global ad-hoc fallback, and mise
shadows it with a pinned version inside project directories. That shadowing is
the system working as designed. The question to ask per tool: "do I run this
outside a pinning project?"

- Kept in brew as global fallbacks: az, k9s, yq, uv, helm.
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

Theme switching uses the `starship-theme` function (`.config/zsh/functions/`):

- Base config: `.config/starship/config.toml` (set `palette = 'name'`)
- Palettes: `.config/starship/themes/*.toml`
- Output: `.config/starship/starship.toml` (gitignored, generated by `20-prompt.zsh` if missing)
