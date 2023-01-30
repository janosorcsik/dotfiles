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

# Remove last login text
touch ~/.hushlogin

echo "Git..."
sudo rm ~/.gitconfig
ln -s ~/.dotfiles/gitconfig ~/.gitconfig

echo "Tmux..."
sudo rm ~/.tmux.conf
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

echo "Install Tmux plugins..."
sudo rm -rf ~/.tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Nvim..."
sudo rm -rf ~/.config/nvim
ln -s ~/.dotfiles/nvim ~/.config/nvim
