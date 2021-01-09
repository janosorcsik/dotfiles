#!/usr/bin/env bash

mas upgrade
brew update
brew upgrade --fetch-HEAD

brew cu --all --yes --quiet --no-brew-update

brew cleanup -s
rm -rf "$(brew --cache)"

brew bundle dump --global --force --describe --no-lock
