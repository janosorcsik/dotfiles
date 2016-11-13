#!/usr/bin/env bash
set -ux

mas upgrade
brew update
brew upgrade

brew cu
[[ $? -ne 0 ]] && brew tap buo/cask-upgrade && brew cu

brew cleanup
brew cask cleanup

brew prune

brew bundle dump --force
