# ~/.zprofile
#
# .zprofile is a startup file for login shells, used once during a login session
# to set environment variables like PATH and EDITOR that should be inherited by subshells.

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Path
export PATH=$PATH:~/bin
