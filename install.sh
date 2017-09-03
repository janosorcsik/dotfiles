#!/usr/bin/env bash
set -ux

echo 'Start installing...'

export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/usr/local/Caskroom"

echo "Installing HomeBrew and apps..."
ln -s $PWD/Brewfile ~/Brewfile
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/bundle
brew bundle
brew linkapps

# Reload QuickLook
qlmanage -r

echo "Zsh..."
sudo rm ~/.zshrc
echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh
ln -s $PWD/zshrc ~/.zshrc
sudo rm -rf ~/.zsh
mkdir ~/.zsh
ln -s $PWD/zsh/* ~/.zsh/

echo "Git..."
sudo rm ~/.gitconfig
ln -s $PWD/gitconfig ~/.gitconfig

echo "NVM..."
sudo rm -rf ~/.nvm
. "$(brew --prefix nvm)/nvm.sh"
nvm install stable && nvm use stable

echo "NPM..."
sudo npm install -g diff-so-fancy eslint

echo "Skype..."
sudo rm ~/Library/Application\ Support/Skype/orcsik.janos/main.db
ln -s ~/Dropbox/Skype/main.db ~/Library/Application\ Support/Skype/orcsik.janos/main.db
