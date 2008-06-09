source ~/.bashrc

# setup macports' path
export PATH=/port/bin:/port/sbin:$PATH

# setup fink and its path
test -r /sw/bin/init.sh && . /sw/bin/init.sh

# setup local and private paths
export PATH=/Users/fredrik/jdk/soylatte16-i386-1.0.2/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
