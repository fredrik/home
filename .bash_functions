function rehash() {
    echo "reloading .bash_profile"
    source $HOME/.bash_profile
}

function bssh() {
     ssh -tt badger.last.fm ssh -A $1
}

alias sync-torrents='rsync -avu ~/torrent-files/*.torrent mosfet:~/.torrent-watch --ignore-existing'
alias suck-back-mosfet='rsync --archive --verbose --update -r mosfet:~/torrent/* --ignore-existing --progress /Volumes/data/incoming/sync-mosfet'
