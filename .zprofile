# ~/.zprofile
# ~/.zprofile is a startup file for login shells, used once during a login session
# to set environment variables like PATH and EDITOR that should be inherited by subshells.

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# nix
export PATH="$PATH:$HOME/.nix-profile/bin"

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

