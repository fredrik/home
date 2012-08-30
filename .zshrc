PROMPT='[%~]> '

export PATH=/usr/local/share/python:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin


HISTSIZE=10000 # session history size
SAVEHIST=1000 # saved history

# git completion.
autoload -U compinit && compinit

source ~/.aliases

if [[ -f /usr/local/share/python/virtualenvwrapper.sh ]]; then
  source /usr/local/share/python/virtualenvwrapper.sh
fi

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python


# aws auths
if [[ -f ~/.aws ]]; then
  source ~/.aws
fi

