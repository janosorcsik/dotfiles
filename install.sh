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
ln -s ~/.dotfiles/p10k.zsh ~/.p10k.zsh

# Install Catppuccin theme
sudo rm ~/.catppuccin_mocha-zsh-syntax-highlighting.zsh
ln -s ~/.dotfiles/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh ~/.catppuccin_mocha-zsh-syntax-highlighting.zsh

# Remove last login text
touch ~/.hushlogin

echo "Git..."
sudo rm ~/.gitconfig
ln -s ~/.dotfiles/gitconfig ~/.gitconfig

echo "Ghostty..."
sudo rm -rf ~/.config/ghostty
ln -s ~/.dotfiles/config/ghostty ~/.config/ghostty

echo "Nvim..."
sudo rm -rf ~/.config/nvim
ln -s ~/.dotfiles/config/nvim ~/.config/nvim

echo "Bat..."
sudo rm -rf ~/.config/bat
ln -s ~/.dotfiles/config/bat ~/.config/bat
bat cache --build

echo "IdeaVim..."
sudo rm ~/.ideavimrc
ln -s ~/.dotfiles/ideavimrc ~/.ideavimrc

echo "Nvm..."
sudo rm -rf ~/.zsh-nvm
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
