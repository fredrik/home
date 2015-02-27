PROMPT='[%~]> ⚡  '

echo work hard and be nice to people

# git completion.
autoload -U compinit && compinit

source ~/.aliases
source ~/.zsh-gpg



# rbenv
eval "$(rbenv init -)"


rehash() {
    # reload all the configuration.
    source ~/.zshrc
}
