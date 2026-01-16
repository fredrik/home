# ~/.zshenv
#
# .zshenv is sourced first and always for every zsh instance.

# neovim
export EDITOR='nvim'
export VISUAL='nvim'

# moor
export PAGER='moor'
# moor doesn't have a config file and is instead configured via the $MOOR variable.
export MOOR='--quit-if-one-screen --statusbar=bold'

# locale, etc
export LANG=en_SE.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# feature flags, etc
export HOMEBREW_NO_ENV_HINTS=true
export DOCKER_CLI_HINTS=false
