# Dotfiles tasks

# List available commands
[default]
list:
    @just --list

# Dump current Homebrew packages to Brewfile
brew-dump:
    brew bundle dump -f --file ~/.config/brew/Brewfile

# Install packages from Brewfile
brew-install:
    brew bundle --file ~/.config/brew/Brewfile

# Regenerate starship.toml from config and themes
starship-build:
    cat ~/.config/starship/config.toml ~/.config/starship/themes/*.toml > ~/.config/starship/starship.toml
