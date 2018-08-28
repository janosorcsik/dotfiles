#!/usr/bin/env bash

mas upgrade
brew update
brew upgrade --fetch-HEAD

brew cu --all --yes --quiet --no-brew-update

brew bundle dump --global --force

brew prune

brew cleanup -s
rm -rf "$(brew --cache)"
