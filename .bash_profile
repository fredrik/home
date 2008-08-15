
# disable ^S and ^Q
stty stop undef
stty start undef

source ~/.bashrc
source ~/.bash_alias
source ~/.bash_functions


# amazon aws
if [[ -f "$HOME/.amazon_keys" ]]; then
  source "$HOME/.amazon_keys";
fi

# hadoop
if [[ -f "$HOME/.hadoop" ]]; then
  source "$HOME/.hadoop";
fi

# EC2
if [[ -f "$HOME/.ec2" ]]; then
  source "$HOME/.ec2";
fi
