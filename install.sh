#!/usr/bin/env sh
set -ux

echo "Installing Command Line Tools"
xcode-select install

echo "Installing HomeBrew and apps..."
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

sudo rm ~/.Brewfile
ln -s ~/.dotfiles/Brewfile ~/.Brewfile
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew tap homebrew/bundle
brew bundle --global

# Reload QuickLook
qlmanage -r

echo "Zsh..."
sudo rm ~/.zshrc ~/.zprofile
chsh -s /bin/zsh
ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/zprofile ~/.zprofile

# Install Powerlevel10k Pure prompt
sudo rm ~/.p10k.zsh
ln -s ~/.dotfiles/zsh/p10k.zsh ~/.p10k.zsh

# Install Catppuccin theme
sudo rm ~/.catppuccin_mocha-zsh-syntax-highlighting.zsh
ln -s ~/.dotfiles/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh ~/.catppuccin_mocha-zsh-syntax-highlighting.zsh

# Remove last login text
touch ~/.hushlogin

echo "Git..."
sudo rm ~/.gitconfig
ln -s ~/.dotfiles/gitconfig ~/.gitconfig

echo "Ghostty..."
sudo rm ~/.config/ghostty/config
ln -s ~/.dotfiles/ghostty.conf ~/.config/ghostty/config

echo "Nvim..."
sudo rm -rf ~/.config/nvim
ln -s ~/.dotfiles/nvim ~/.config/nvim
