# ~/.zshenv
#
# .zshenv is sourced first and always for every zsh instance.

# git
# Prevents git from finding ~/.git when in subdirectories like ~/Library
# This means I can only interact with the ~/ git repo from ~/
export GIT_CEILING_DIRECTORIES="$HOME"

# locale: use en_US to keep it simple.
# I used to run English language with Swedish regional formatting
# but that was broken in some number of annoying ways.
export LANG=en_US.UTF-8

# make sure we have the right XDG config
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# to make some zsh-specific things like dotenv work
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# automatically load .env
export ZSH_DOTENV_PROMPT=false

# neovim
export EDITOR='nvim'
export VISUAL='nvim'

# go
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GOBIN="$HOME/.local/bin"

# eza
export EZA_ICONS_AUTO=true

# moor
# moor has no config file; it's configured via the $MOOR variable.
export PAGER='moor'
export MOOR='--quit-if-one-screen --no-statusbar'

# starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# feature flags, etc
export HOMEBREW_NO_ENV_HINTS=true
export HOMEBREW_NO_AUTO_UPDATE=1
export DOCKER_CLI_HINTS=false
