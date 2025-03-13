# Brew and Cask update
function bu {
  mas upgrade
  brew update
  brew upgrade --fetch-HEAD
  brew cu --all --yes --quiet --no-brew-update
  brew cleanup -s
  rm -rf "$(brew --cache)"
  brew bundle dump --global --force --describe
}

# Git cleanup
function gitc {
  git branch -r --merged | grep -v '\*\|master\|main\|develop\|release' | sed 's/origin\///' | xargs -n 1 git push --delete origin
  git fetch --prune
  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D
}
