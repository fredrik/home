function rehash() {
    echo "reloading .bash_profile"
    source $HOME/.bash_profile
}

function bssh() {
     ssh -tt badger.last.fm ssh -A $1
}

function didwhat() {
	commit=$1
	git diff $commit^ $commit
}

# textmate
function m() {
	mate $@ & 2> /dev/null
}
