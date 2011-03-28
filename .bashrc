export LC_CTYPE=en_GB.UTF-8
# export LC_CTYPE=en_US.UTF-8
# export LC_CTYPE=sv_SE.UTF-8

# infinite history.
unset HISTFILESIZE

if [ `uname` = "Darwin" ]; then
    # this is the hackintosh, then.
    export PS1="[\w]:\$> "
    export EDITOR='mate -w'
    export GIT_EDITOR='mate -w'

    export HADOOP_HOME='/usr/local/hadoop'
    export HBASE_HOME='/usr/local/hbase'
    export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home"
    export PRICEMONSTER_HOME='/Users/fredrik/editd/pricemonster'

else
    # otherwise, any remote system.
    export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:[\[\033[01;34m\]\w\[\033[00m\]]\$ '
    export EDITOR='vim'
    export GIT_EDITOR='vim'
fi
