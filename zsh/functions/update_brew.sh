#!/usr/bin/env bash

mas upgrade
brew update
brew upgrade

brew cu --all --yes --cleanup

brew bundle dump --force

brew cleanup
brew cask cleanup

brew prune
