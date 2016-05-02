#! /bin/sh

echo 'Start installing...'

echo "Installing XCode..."
xcode-select --install

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

echo "Installing HomeBrew and apps..."
sudo rm -rf ~/.brewfile
mkdir ~/.brewfile/
ln -s $PWD/Brewfile ~/.brewfile/
curl -fsSL https://raw.github.com/rcmdnk/homebrew-file/install/install.sh |sh
brew-file install

# Reload QuickLook
qlmanage -r

echo "Installing config..."
sudo rm -rf ~/.config
mkdir ~/.config
ln -s $PWD/config/* ~/.config/

echo "Zsh..."
sudo rm ~/.zshrc
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
npm install -g bower gulp

echo "Skype..."
sudo rm ~/Library/Application\ Support/Skype/orcsik.janos/main.db
ln -s ~/Dropbox/Skype/main.db ~/Library/Application\ Support/Skype/orcsik.janos/main.db

echo "OS X..."
sh .osx
