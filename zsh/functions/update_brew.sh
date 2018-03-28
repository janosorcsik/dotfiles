#!/usr/bin/env bash

mas upgrade
brew update
brew upgrade

brew cu --yes --cleanup --quiet --no-brew-update

brew bundle dump --global --force

brew prune

brew cleanup --force -s
brew cask cleanup
rm -rf `brew --cache`
