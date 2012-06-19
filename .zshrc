PROMPT='[%~]> '

export PATH=$PATH:/usr/local/sbin

source /usr/local/bin/virtualenvwrapper.sh

## aliases
# git
alias status='git status'
alias add='git add .'
alias commit='git commit'
alias branch='git branch' 
alias checkout='git checkout'
alias push='git push origin master'
alias fetch='git fetch --all'
# more.
alias undo='echo "UNDOING COMMIT."; git reset --soft HEAD^'
alias lastdiff='git diff HEAD^ HEAD'
alias commit_all='echo "COMMITING."; git commit -a'
# shorties.
alias a='git add'
alias b='git branch'
alias co=checkout
alias s=status
alias l='git log --stat --abbrev-commit'
alias d='git diff'
alias dd='git diff --cached'
alias ddd=lastdiff
alias c=commit
alias cc=commit_all
