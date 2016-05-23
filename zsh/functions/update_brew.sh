#!/bin/bash
brew update
brew upgrade --all

brew cask update
for c in `brew cask list`; do
  ! brew cask info $c | grep -qF "Not installed" || brew cask install --force $c
done

brew cleanup
brew cask cleanup
brew bundle dump --force
