#!/usr/bin/env sh
set -e

DOTFILES="$HOME/Developer/dotfiles"

echo "Installing Command Line Tools..."
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Waiting for Command Line Tools to finish installing..."
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

echo "Installing Homebrew and apps..."
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

ln -sfn "$DOTFILES/Brewfile" "$HOME/.Brewfile"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --global

# Reload QuickLook
qlmanage -r

echo "Zsh..."
# zshenv sets ZDOTDIR=~/.config/zsh, so zsh loads .zshrc/.zprofile from there
ln -sfn "$DOTFILES/zshenv" "$HOME/.zshenv"

# Remove last login text
touch "$HOME/.hushlogin"

echo "Linking config directories..."
mkdir -p "$HOME/.config"
for target in "$DOTFILES"/config/*; do
  ln -sfn "$target" "$HOME/.config/$(basename "$target")"
done

# Build bat's syntax/theme cache
bat cache --build

echo "Dotnet global tools..."
dotnet tool install -g roslyn-language-server --prerelease
dotnet tool install -g dotnet-ef
