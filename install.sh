#!/usr/bin/env sh

echo "Installing Command Line Tools"
xcode-select --install

echo "Installing HomeBrew and apps..."
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

sudo rm ~/.Brewfile
ln -s ~/Developer/dotfiles/Brewfile ~/.Brewfile
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle --global

# Reload QuickLook
qlmanage -r

echo "Zsh..."
sudo rm ~/.zshrc ~/.zprofile
chsh -s /bin/zsh
ln -s ~/Developer/dotfiles/zshrc ~/.zshrc
ln -s ~/Developer/dotfiles/zprofile ~/.zprofile
sudo rm -rf ~/.zsh
ln -s ~/Developer/dotfiles/zsh ~/.zsh

# Install Powerlevel10k Pure prompt
sudo rm ~/.p10k.zsh
ln -s ~/Developer/dotfiles/p10k.zsh ~/.p10k.zsh

# Install Catppuccin theme
sudo rm ~/.catppuccin_mocha-zsh-syntax-highlighting.zsh
ln -s ~/Developer/dotfiles/catpuccin/zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh ~/.catppuccin_mocha-zsh-syntax-highlighting.zsh

# Remove last login text
touch ~/.hushlogin

echo "Git..."
sudo rm ~/.gitconfig
ln -s ~/Developer/dotfiles/gitconfig ~/.gitconfig

echo "Ghostty..."
sudo rm -rf ~/.config/ghostty
mkdir -p  ~/.config/ghostty
ln -s ~/Developer/dotfiles/catpuccin/ghostty/themes ~/.config/ghostty/themes
ln -s ~/Developer/dotfiles/config/ghostty/config ~/.config/ghostty/config
sudo rm -rf ~/Library/Application\ Support/com.mitchellh.ghostty/config

echo "Nvim..."
sudo rm -rf ~/.config/nvim
ln -s ~/Developer/dotfiles/config/nvim ~/.config/nvim

echo "Bat..."
sudo rm -rf ~/.config/bat
mkdir -p ~/.config/bat
ln -s ~/Developer/dotfiles/catpuccin/bat/themes ~/.config/bat/themes
ln -s ~/Developer/dotfiles/config/bat/config ~/.config/bat/config
bat cache --build

echo "IdeaVim..."
sudo rm ~/.ideavimrc
ln -s ~/Developer/dotfiles/ideavimrc ~/.ideavimrc

echo "Zsh nvm..."
sudo rm -rf ~/.zsh-nvm
ln -s ~/Developer/dotfiles/zsh-nvm ~/.zsh-nvm

echo "Delta..."
sudo rm ~/catppuccin.gitconfig
ln -s ~/Developer/dotfiles/catpuccin/delta/catppuccin.gitconfig ~/catppuccin.gitconfig
