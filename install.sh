#!/usr/bin/env sh
set -e

echo "Installing Command Line Tools"
xcode-select -p &>/dev/null || xcode-select --install

echo "Installing HomeBrew and apps..."
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

rm -f ~/.Brewfile
ln -s ~/Developer/dotfiles/Brewfile ~/.Brewfile
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --global

# Reload QuickLook
qlmanage -r

echo "Zsh..."
rm -f ~/.zshrc ~/.zprofile
ln -s ~/Developer/dotfiles/zshrc ~/.zshrc
ln -s ~/Developer/dotfiles/zprofile ~/.zprofile
rm -rf ~/.zsh
ln -s ~/Developer/dotfiles/zsh ~/.zsh

# Install Powerlevel10k Pure prompt
rm -f ~/.p10k.zsh
ln -s ~/Developer/dotfiles/p10k.zsh ~/.p10k.zsh

# Remove last login text
touch ~/.hushlogin

echo "Git..."
rm -f ~/.gitconfig
ln -s ~/Developer/dotfiles/gitconfig ~/.gitconfig

echo "Ghostty..."
rm -rf ~/.config/ghostty
ln -s ~/Developer/dotfiles/config/ghostty ~/.config/ghostty

echo "Nvim..."
rm -rf ~/.config/nvim
ln -s ~/Developer/dotfiles/config/nvim ~/.config/nvim

echo "Bat..."
rm -rf ~/.config/bat
ln -s ~/Developer/dotfiles/config/bat ~/.config/bat
bat cache --build

echo "IdeaVim..."
rm -f ~/.ideavimrc
ln -s ~/Developer/dotfiles/ideavimrc ~/.ideavimrc

echo "Halloy..."
rm -rf ~/.config/halloy
ln -s ~/Developer/dotfiles/config/halloy ~/.config/halloy

echo "OpenCode..."
rm -rf ~/.config/opencode
ln -s ~/Developer/dotfiles/config/opencode ~/.config/opencode

echo "Dotnet global tools..."
dotnet tool install -g roslyn-language-server --prerelease
dotnet tool install -g dotnet-ef
