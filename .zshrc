PROMPT='[%~]> '

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/X11/bin

# git completion.
autoload -U compinit && compinit

source ~/.aliases

if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi

