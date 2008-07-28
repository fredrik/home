source ~/.bash_alias
source ~/.bash_functions

# PS1, PATH, svedese
export PS1="\[\033[01;32m\]lenbust@dlx:\033[00m\][\[\033[01;34m\]\w\[\033[00m\]]> "

# Java
#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
export JAVA_HOME=/Users/fredrik/jdk/soylatte16-i386-1.0.2

# python (mercurial, http://www.selenic.com/mercurial/wiki/index.cgi/UnixInstall)
export PYTHONPATH=${HOME}/lib/python


export LC_CTYPE="sv_SE.UTF-8"
#export LC_CTYPE=en_US.UTF-8

# textmate edits commit messages
export SVN_EDITOR='mate -w'

# disable ^S and ^Q
stty stop undef
stty start undef

# 
EDITOR=emacs


# amazon aws
if [[ -f "$HOME/.amazon_keys" ]]; then
  source "$HOME/.amazon_keys";
fi


function rehash() {
    echo "reloading .bashrc"
    source $HOME/.bashrc
}
