echo work hard and be nice to people

# zsh plugins
plugins=(git zsh-autosuggestions fzf-tab z)

export ZSH="/Users/fredrik/.oh-my-zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "$HOME/.cache/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "$HOME/.cache/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# p10k prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# zsh syntax highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting
# via https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/zsh-syntax-highlighting.rb
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


## Configuration
# make the autosuggest colour fade into the background a bit more.
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'
# Show date stamp of commands in history.
export HIST_STAMPS="yyyy-mm-dd"


# OH MY!
source $ZSH/oh-my-zsh.sh



# ------------------------------------------------------------ !
# main shell configuration.
#
# inspiration for what zsh configuration should go where:
# https://unix.stackexchange.com/a/487889


## PATH etc
# Prepend coreutils to path in order to use gnu versions of common utilities
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# Use RVM
export PATH="$PATH:$HOME/.rvm/bin"

## 
# locale, because perl complains.
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# configure less to show diffs inline without paging
# if output is less than one page.
export LESS="-FXR"



## Aliases etc.
# configure `ls`.
# list with colour (-G)
# and symbols that indicate type (-F)
alias ls='ls -FG'
# simple aliases.
# ('-o' omits group name from list)
alias ll='ls -lo'
alias lla='ls -loa'

# git shorties
alias add='git add .'
alias b='git branch'
alias c='git commit'
alias cc='git commit -a'
alias d='git diff'
alias dd='git diff --cached'
alias ddd='git diff HEAD^ HEAD'
alias l='git log --stat --abbrev-commit'
alias s='git status'
alias t='git log --oneline --decorate --graph'


## managers of various kinds.
# load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"

# fzf
# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--height 7 --border'

# fzf + z
unalias z 2> /dev/null
z() {
    [ $# -gt 0 ] && zshz "$*" && return
    cd "$(zshz -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}
alias j=z # easier to reach 'j' than 'z'

# also, make history local.
# via https://superuser.com/questions/446594/separate-up-arrow-lookback-for-local-and-global-zsh-history
up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}

zle -N up-line-or-local-history
zle -N down-line-or-local-history

bindkey "${key[Up]}" up-line-or-local-history
bindkey "${key[Down]}" down-line-or-local-history

# git: switching to a recent branch
# via https://github.com/jbranchaud/til/blob/master/git/switch-to-a-recent-branch-with-fzf.md
fsw() {
  local branches branch
  branches=$(git for-each-ref --count=16 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" | fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git switch $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}


# Make sure the caret (in "HEAD^" for example) works as I'm used to.
# For some reason, using rvm changes this behaviour and it's somehow related to extendedglob.
# via https://github.com/ohmyzsh/ohmyzsh/issues/449
setopt NO_NOMATCH
