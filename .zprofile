# ~/.zprofile
#
# .zprofile is a startup file for login shells, used once during a login session
# to set environment variables like PATH and EDITOR that should be inherited by subshells.

# Aliases
source ~/.zshrc.aliases

# Path
export PATH=$PATH:~/bin

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Mise
eval "$(mise activate zsh)"
