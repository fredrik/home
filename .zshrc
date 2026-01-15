# ~/.zshrc
echo work hard and be nice to people


#
# Here's the sourcing order for zsh configurations:
#   Login interactive:     .zshenv → .zprofile → .zshrc → .zlogin (→ .zlogout)
#   Non-login interactive: .zshenv → .zshrc
#   Non-interactive:       .zshenv
#
# .zshenv  = always, all shells (PATH, env vars needed by scripts)
# .zprofile = login only, before .zshrc (env setup)
# .zshrc   = interactive (prompt, aliases, keybindings, completions)
# .zlogin  = login only, after .zshrc (rarely used)
#
# Login: first shell of session
# Non-login: child shell (new tab, `zsh`, tmux pane)
# Interactive = human at prompt
# Non-interactive = scripts, cron, `zsh -c "..."`
#


# starship
eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"


# history forever
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt EXTENDED_HISTORY      # Timestamp entries
unsetopt SHARE_HISTORY       # Don't import other sessions' history (up arrow doesn't include other sessions' history)
setopt INC_APPEND_HISTORY    # Write immediately (global search works)
setopt HIST_IGNORE_DUPS      # Skip consecutive duplicates
unsetopt HIST_IGNORE_SPACE   # Skip commands starting with space
setopt HIST_VERIFY           # Show before executing from history
