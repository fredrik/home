
## $PS1
export PS1="[\w]:\$> "
#export PS1="\[\033[01;32m\]lenbust@dlx:\033[00m\][\[\033[01;34m\]\w\[\033[00m\]]> "

## PATH
# setup macports' path
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# setup fink and its path
test -r /sw/bin/init.sh && . /sw/bin/init.sh
# add local and private paths
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

# macport man pages.
export MANPATH=/opt/local/share/man:$MANPATH

# add soylatte's binaries to path
#export PATH=/usr/local/soylatte16-i386-1.0.3/bin:$PATH

# Java
# soylatte:
#export JAVA_HOME=/usr/local/soylatte16-i386-1.0.3
# std:
#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home

# python (mercurial, http://www.selenic.com/mercurial/wiki/index.cgi/UnixInstall)
#export PYTHONPATH=${HOME}/lib/python


export LC_CTYPE="sv_SE.UTF-8"
#export LC_CTYPE=en_US.UTF-8

export EDITOR=emacs
export GIT_EDITOR='mate -w'
