#!/usr/bin/env bash
set -ux

echo 'Start installing...'

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

echo "Installing HomeBrew and apps..."
ln -s ~/.dotfiles/Brewfile ~/.Brewfile
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/bundle
brew bundle

# Reload QuickLook
qlmanage -r

echo "Zsh..."
sudo rm ~/.zshrc
echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh
ln -s ~/.dotfiles/zshrc ~/.zshrc
sudo rm ~/.zsh_plugins.txt
ln -s ~/.dotfiles/zsh_plugins.txt ~/.zsh_plugins.txt
sudo rm -rf ~/.zsh
mkdir ~/.zsh
ln -s ~/.dotfiles/zsh/* ~/.zsh/

echo "Git..."
sudo rm ~/.gitconfig
ln -s ~/.dotfiles/gitconfig ~/.gitconfig

echo "NPM..."
sudo npm install -g eslint spaceship-prompt

echo "Skype..."
sudo rm ~/Library/Application\ Support/Skype/orcsik.janos/main.db
ln -s ~/Dropbox/Skype/main.db ~/Library/Application\ Support/Skype/orcsik.janos/main.db
