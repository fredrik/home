# ~/.zshrc @ vcc
#

# PATH
export PATH="$PATH:/Users/FMOLLERS/.local/bin"

# homebrew
export HOMEBREW_NO_ENV_HINTS=true
export HOMEBREW_NO_AUTO_UPDATE=true

# docker
export DOCKER_CLI_HINTS=false

# p10k
source ~/.p10k.init.zsh

# fzf
eval "$(fzf --zsh)"
