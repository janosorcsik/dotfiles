#!/usr/bin/env sh
set -e

DOTFILES="$HOME/Developer/dotfiles"

# zshenv only runs for interactive zsh, but the steps below (dotnet global tools,
# XDG paths) depend on the variables it exports, so load it up front.
. "$DOTFILES/zshenv"

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

# The installer writes to ~/.zprofile but does not touch the running shell,
# so brew (and everything it installs) is not on PATH yet.
eval "$(/opt/homebrew/bin/brew shellenv)"

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
  link="$HOME/.config/$(basename "$target")"

  # ln -sfn does not replace a real directory, it silently creates the symlink
  # *inside* it and still exits 0, so remove any non-symlink first.
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "  replacing $link"
    rm -rf "$link"
  fi

  ln -sfn "$target" "$link"
done

echo "Dotnet global tools..."
dotnet tool update -g roslyn-language-server --prerelease
dotnet tool update -g dotnet-ef
dotnet tool update -g JetBrains.ReSharper.GlobalTools
