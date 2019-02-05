# a basic configuration file that uses oh-my-zsh.

export EDITOR=vim
export LANG=en_EN.UTF-8
export LESSCHARSET=UTF-8 # åäö
export TERM="xterm-256color"

# rbenv :)
eval "$(rbenv init -)"


### --- oh my zsh

# Path to your oh-my-zsh installation.
export ZSH=/Users/fredrik/.oh-my-zsh

# powerlevel9k
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)

plugins=(git)

source $ZSH/oh-my-zsh.sh


# User configuration

# :-)
