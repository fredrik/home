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

# Symlink VS Code settings to Application Support
vscode-link:
    ln -sf ~/.config/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
    ln -sf ~/.config/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
