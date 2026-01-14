# ~/.zshrc

# starship
eval "$(starship init zsh)"

# history forever
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt EXTENDED_HISTORY      # Timestamp entries
unsetopt SHARE_HISTORY       # Don't import other sessions' history (up arrow doesn't include other sessions' history)
setopt INC_APPEND_HISTORY    # Write immediately (global search works)
setopt HIST_IGNORE_DUPS      # Skip consecutive duplicates
setopt HIST_IGNORE_SPACE     # Skip commands starting with space
setopt HIST_VERIFY           # Show before executing from history

export PATH=$PATH:~/bin
