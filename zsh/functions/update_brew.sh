#!/usr/bin/env bash

mas upgrade
brew update
brew upgrade --fetch-HEAD

brew cu --all --yes --cleanup --quiet --no-brew-update

brew bundle dump --global --force

brew prune

brew cleanup -s
rm -rf "$(brew --cache)"
