
## $PS1
export PS1="\[\033[01;32m\]lenbust@dlx:\033[00m\][\[\033[01;34m\]\w\[\033[00m\]]> "

## PATH
# setup macports' path
export PATH=/port/bin:/port/sbin:$PATH

# setup fink and its path
test -r /sw/bin/init.sh && . /sw/bin/init.sh

# setup local and private paths
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH


# Java
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home

# python (mercurial, http://www.selenic.com/mercurial/wiki/index.cgi/UnixInstall)
export PYTHONPATH=${HOME}/lib/python


export LC_CTYPE="sv_SE.UTF-8"
#export LC_CTYPE=en_US.UTF-8

export EDITOR=emacs
export GIT_EDITOR='mate -w'
