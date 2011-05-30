function rehash() {
    echo "reloading .bash_profile"
    source $HOME/.bash_profile
}

function jump() {
     ssh -A -tt punktlich ssh -A $1
}
alias j=jump

function didwhat() {
	commit=$1
	git diff $commit^ $commit
}

# textmate
function m() {
	mate $@ & 2> /dev/null
}
