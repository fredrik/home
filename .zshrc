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

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Mise
eval "$(mise activate zsh)"

# starship for prompt
# should go last
eval "$(starship init zsh)"

# --------

# history forever
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt EXTENDED_HISTORY      # Timestamp entries
unsetopt SHARE_HISTORY       # Don't import other sessions' history (up arrow doesn't include other sessions' history)
setopt INC_APPEND_HISTORY    # Write immediately (global search works)
setopt HIST_IGNORE_DUPS      # Skip consecutive duplicates
setopt HIST_VERIFY           # Show before executing from history

# comments are welcome.
setopt INTERACTIVE_COMMENTS

# Change into newly created directory.
take() { mkdir -p "$1" && cd "$1" }

# reload this configuration.
rehash() { source ~/.zshrc }

# disable flow control and free up ctrl-s and ctrl-q
stty -ixon

# use vim mode, but restore the essential emacs-like ctrl-based commands.
# note that 'bindkey -v' needs to be the first bindkey call.
bindkey -v
KEYTIMEOUT=1
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^Y' yank
bindkey '^Q' kill-word
bindkey '^W' backward-kill-word
bindkey '^D' delete-char

# re-bind keys after vi mode did it's thing.
# restore ctrl-f for autocompletion
bindkey '^F' autosuggest-accept
bindkey '^X^E' edit-command-line

# Path
export PATH=$PATH:~/.local/bin

# --------

# Aliases
source ~/.zshrc.aliases
