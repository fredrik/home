function rehash() {
    echo "reloading .bash_profile"
    source $HOME/.bash_profile
}

function jump() {
    ssh -A -tt $1 ssh -A $2
}
alias j=jump
