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

# completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case-insensitive

# edit command line with Ctrl-X Ctrl-E
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# fzf for fuzzy searching
source <(fzf --zsh)
# fzf keybindings:
# Ctrl-R: fuzzy history search
# Ctrl-T: fuzzy file picker, inserts path
# Alt-C: fuzzy cd into directory
# fzf completion (trigger with **<tab>):
# vim **<tab>: fuzzy file search
# cd **<tab>: fuzzy directory search
# ssh **<tab>: fuzzy host completion

# zoxide for directory jumping
eval "$(zoxide init zsh)"

# sheldon for plugins
eval "$(sheldon source)"
# see ~/.config/sheldon/plugins.toml
# I'm using zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab.
#
# zsh-autosuggestions:
# Ctrl-F: accept full suggestion
# Option-→: accept one word

# starship for prompt
# should go last
eval "$(starship init zsh)"


# history forever
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt EXTENDED_HISTORY      # Timestamp entries
unsetopt SHARE_HISTORY       # Don't import other sessions' history (up arrow doesn't include other sessions' history)
setopt INC_APPEND_HISTORY    # Write immediately (global search works)
setopt HIST_IGNORE_DUPS      # Skip consecutive duplicates
setopt HIST_VERIFY           # Show before executing from history
