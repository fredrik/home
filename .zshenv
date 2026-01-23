# ~/.zshenv
#
# .zshenv is sourced first and always for every zsh instance.

# make sure we have the right XDG config
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# to make some zsh specific things like dotenv work
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# automatically load .env
export ZSH_DOTENV_PROMPT=false

# neovim
export EDITOR='nvim'
export VISUAL='nvim'

# eza
export EZA_ICONS_AUTO=true

# moor
export PAGER='moor'
# moor doesn't have a config file and is instead configured via the $MOOR variable.
export MOOR='--quit-if-one-screen --no-statusbar'

# locale: English language with Swedish regional formatting
export LANG=en_US.UTF-8
export LC_TIME=sv_SE.UTF-8
export LC_NUMERIC=sv_SE.UTF-8
export LC_MONETARY=sv_SE.UTF-8

# starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# feature flags, etc
export HOMEBREW_NO_ENV_HINTS=true
export DOCKER_CLI_HINTS=false

# git
# Prevents git from finding ~/.git when in subdirectories like ~/Library
# This means I can only interact with the ~/ git repo from ~/
export GIT_CEILING_DIRECTORIES="$HOME"
