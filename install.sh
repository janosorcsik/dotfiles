#!/usr/bin/env bash
set -ux

echo 'Start installing...'
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

echo "Installing HomeBrew and apps..."
ln -s ~/.dotfiles/Brewfile ~/.Brewfile
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/bundle
brew bundle --global

# Reload QuickLook
qlmanage -r

echo "Zsh..."
sudo rm ~/.zshrc
echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh
ln -s ~/.dotfiles/zshrc ~/.zshrc
sudo rm -rf ~/.zsh
mkdir ~/.zsh
ln -s ~/.dotfiles/zsh/* ~/.zsh/

# Remove last login text
touch ~/.hushlogin

echo "Git..."
sudo rm ~/.gitconfig
ln -s ~/.dotfiles/gitconfig ~/.gitconfig

echo "NPM..."
sudo npm install -g spaceship-prompt

echo "Skype..."
sudo rm ~/Library/Application\ Support/Skype/orcsik.janos/main.db
ln -s ~/Dropbox/Skype/main.db ~/Library/Application\ Support/Skype/orcsik.janos/main.db
