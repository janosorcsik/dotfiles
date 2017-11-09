#!/usr/bin/env bash

mas upgrade
brew update
brew upgrade

brew cu --yes --cleanup --quiet

brew bundle dump --force

brew cleanup
brew cask cleanup

brew prune
