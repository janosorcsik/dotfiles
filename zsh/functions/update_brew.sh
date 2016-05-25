#!/bin/bash
mas upgrade
brew update
brew upgrade --all

brew cask update
for c in `brew cask list`; do
  ! brew cask info $c | grep -qF "Not installed" || brew cask install --force $c
done

for c in /opt/homebrew-cask/Caskroom/*; do vl=(`ls -t $c`) && for v in "${vl[@]:1}"; do sudo rm -rf "$c/$v"; done; done

brew cleanup
brew prune
brew cask cleanup
brew bundle dump --force
