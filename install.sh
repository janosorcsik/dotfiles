#! /bin/sh

echo 'Start installing...'

echo "Installing XCode..."
xcode-select --install

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

echo "Installing HomeBrew and apps..."
curl -fsSL https://raw.github.com/rcmdnk/homebrew-file/install/install.sh |sh
mkdir ~/.brewfile/
ln -s $PWD/Brewfile ~/.brewfile/
brew-file install

# Reload QuickLook
qlmanage -r

echo "Installing config.."
mkdir ~/.config
ln -s $PWD/config/* ~/.config/

mkdir ~/.nvm

echo "Zsh..."
chsh -s /usr/local/bin/zsh
ln -s $PWD/zshrc ~/.zshrc

mkdir ~/.zsh
ln -s $PWD/zsh/* ~/.zsh/

echo "Atom..."
mkdir ~/.atom
ln -s $PWD/atom/* ~/.atom/

echo "SSH..."
mkdir ~/.ssh
ln -s $PWD/ssh/* ~/.ssh/

echo "Git..."
ln -s $PWD/gitconfig ~/.gitconfig

echo "OS X..."
sh .osx
