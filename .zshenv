export PATH="$PATH:/Users/FMOLLERS/.local/bin"
export LANG=en_SE.UTF-8

# zsh
# save a million lines of history!
export HISTSIZE=1000000
export SAVEHIST=1000000

# less
export LESSCHARSET=UTF-8
export LESSHISTFILE=/dev/null

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ENV_HINTS=true
export HOMEBREW_NO_AUTO_UPDATE=true
export HOMEBREW_NO_INSTALL_CLEANUP=1

# docker
export DOCKER_CLI_HINTS=false
