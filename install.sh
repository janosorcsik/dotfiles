#!/usr/bin/env sh
set -ux

echo 'Start installing...'
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

echo "Installing HomeBrew and apps..."
ln -s ~/.dotfiles/Brewfile ~/.Brewfile
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew tap homebrew/bundle
brew bundle --global

# Reload QuickLook
qlmanage -r

echo "Zsh..."
sudo rm ~/.zshrc
echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh
ln -s ~/.dotfiles/zshrc ~/.zshrc

# Install Powerlevel10k Pure prompt
sudo rm ~/.p10k.zsh
ln -s ~/.dotfiles/p10k.zsh ~/.p10k.zsh

# Remove last login text
touch ~/.hushlogin

echo "Git..."
sudo rm ~/.gitconfig
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
