#! /bin/sh

echo 'Start installing...'

export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/opt/homebrew-cask/Caskroom"

echo "Installing HomeBrew and apps..."
ln -s $PWD/Brewfile ~/Brewfile
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/bundle
brew bundle
brew linkapps mpv

# Reload QuickLook
qlmanage -r

echo "Installing config..."
sudo rm -rf ~/.config
mkdir ~/.config
ln -s $PWD/config/* ~/.config/

echo "Zsh..."
sudo rm ~/.zshrc
echo '/usr/local/bin/bash' | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh
ln -s $PWD/zshrc ~/.zshrc
sudo rm -rf ~/.zsh
mkdir ~/.zsh
ln -s $PWD/zsh/* ~/.zsh/

echo "Atom..."
sudo rm -rf ~/.atom
mkdir ~/.atom
ln -s $PWD/atom/* ~/.atom/
apm install --packages-file ~/.atom/packages.list

echo "SSH..."
sudo rm -rf ~/.ssh
mkdir ~/.ssh
ln -s $PWD/ssh/* ~/.ssh/

echo "Git..."
sudo rm ~/.gitconfig
ln -s $PWD/gitconfig ~/.gitconfig

echo "NVM..."
sudo rm -rf ~/.nvm
git clone http://github.com/creationix/nvm.git ~/.nvm
sh ~/.nvm/nvm.sh
nvm install stable
nvm alias default stable

echo "NPM..."
npm install -g bower gulp eslint

echo "Skype..."
sudo rm ~/Library/Application\ Support/Skype/orcsik.janos/main.db
ln -s ~/Dropbox/Skype/main.db ~/Library/Application\ Support/Skype/orcsik.janos/main.db

echo "OS X..."
sh .osx
