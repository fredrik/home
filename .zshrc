# ~/.zshrc
#
# My interactive shell, in broad strokes:
#
#   Looks     starship prompt, vivid ls colours
#   Finds     fzf everywhere (Ctrl-R/O/T, Alt-C, **<tab>), zoxide for jumping
#   Plugins   sheldon (autosuggestions, syntax highlighting, fzf-tab), cached
#   Tools     homebrew, mise, direnv
#   Editing   vim mode with the emacs ctrl-keys I can't live without
#   History   effectively infinite, timestamped, with per-session up-arrow
#   Helpers   take, psx, tint, init-project (autoloaded from .config/zsh/functions)
#
# Startup is kept fast: sheldon, brew shellenv and vivid are cached, compinit deferred.
# Config lives in ~/.config/zsh/rc.d, loaded below in numeric order.
#
# Package responsibilities: Homebrew owns the machine, mise owns the work.
#
# See DOTFILES.md.

echo work hard and be nice to people

ZSH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Autoloaded helper functions (one file per function) and personal completions.
fpath=($ZSH_CONFIG/functions $ZSH_CONFIG/completions $fpath)
autoload -Uz $ZSH_CONFIG/functions/*(.N:t)

# Numbered fragments; the number encodes load order. See DOTFILES.md.
for _f in $ZSH_CONFIG/rc.d/*.zsh(N); do source $_f; done; unset _f

# Machine-specific overrides, not tracked.
[[ -r $ZSH_CONFIG/local.zsh ]] && source $ZSH_CONFIG/local.zsh
