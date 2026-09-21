# Aliases. Helper functions live in ../functions/.

# eza instead of ls
alias ls='eza --git'
alias ll='ls -l'
alias lla='ls -la'
alias lt='eza --tree --git-ignore --icons'

# bat instead of cat
alias cat='bat --paging=never'

# moor for less
alias less=moor

# also, remember that you have these:
#  - rg (ripgrep) for searching
#  - fd for finding

# git shorties
alias add='git add .'
alias b='git branch'
alias c='git commit'
alias cc='git commit -a'
alias d='git diff'
alias dd='git diff --cached'
alias ddd='git diff HEAD^ HEAD'
alias l='git log --stat --abbrev-commit --show-signature'
alias s='git status'
alias t='git log --oneline --decorate --graph'
alias sw='git switch'

# my local tools
# claude history
alias ch=claude-history
# worktree-keeper
alias wk=worktree-keeper
# claude-isolated
alias iso=claude-isolated

# claude with a pinned model.
alias fable='claude --model=fable'
alias opus='claude --model=opus'
alias sonnet='claude --model=sonnet'

# mount whatbox seedbox over sshfs (fuse-t)
alias mount-whatbox='mkdir -p ~/whatbox && sshfs whatbox: ~/whatbox -o volname=whatbox,reconnect,follow_symlinks'
alias umount-whatbox='diskutil unmount ~/whatbox'

# Also autoloaded: starship-theme, starship-build, brew-dump, brew-install, httpstatus (functions/).
