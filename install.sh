#! /bin/sh

echo 'Start installing...\n'

echo "Installing XCode...\n"
xcode-select --install

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

echo "\nInstalling HomeBrew and apps...\n"
curl -fsSL https://raw.github.com/rcmdnk/homebrew-file/install/install.sh |sh
mkdir ~/.brewfile/
ln -s $PWD/Brewfile ~/.brewfile/
brew-file install

# Reload QuickLook
qlmanage -r

echo "\nInstalling config..\n"
mkdir ~/.config
ln -s $PWD/config/* ~/.config/

mkdir ~/.nvm

echo "\nZsh...\n"
chsh -s /usr/local/bin/zsh
ln -s $PWD/zshrc ~/.zshrc

mkdir ~/.zsh
ln -s $PWD/zsh/* ~/.zsh/

echo "\nAtom...\n"
mkdir ~/.atom
ln -s $PWD/atom/* ~/.atom/
apm install --packages-file ~/.atom/packages.list

echo "\nSSH...\n"
mkdir ~/.ssh
ln -s $PWD/ssh/* ~/.ssh/

echo "\nGit...\n"
ln -s $PWD/gitconfig ~/.gitconfig

echo "\nOS X...\n"
sh .osx

echo "\nNVM...\n"
nvm install stable
nvm alias default stable
npm install -g bower gulp

echo "\nNPM...\n"
npm install -g gulp
npm install -g bower
