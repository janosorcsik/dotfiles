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

# Clean up remote-tracking merged branches and local orphan branches
function gclean {
  echo "Cleaning remote-tracking merged branches..."
  git branch -r --merged | grep -Ev '\*|main|master|develop|release' | sed 's/origin\///' | while read -r branch; do
    echo " $branch (remote - deleted)"
    git push --delete origin "$branch"
  done

  echo "Cleaning gone-tracking local branches..."
  git fetch --prune
  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | while read -r branch; do
    echo " $branch (gone - local deleted)"
    git branch -D "$branch"
  done

  echo "Looking for local orphan branches..."
  orphans=$(git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads | awk '$2 == "" {print $1}')
  if [[ -n "$orphans" ]]; then
    echo "$orphans" | while read -r branch; do
      echo " $branch (orphan)"
    done
    read "confirm?Delete local orphan branches? (y/n) "
    if [[ "$confirm" == [yY] ]]; then
      echo "$orphans" | xargs -r git branch -D
    fi
  else
    echo "No local orphan branches found."
  fi
}

# Fetch all Git repositories in subfolders
function gfall {
  for dir in */; do
    if [ -d "$dir/.git" ]; then
      branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
      echo "$dir  $branch"
      git -C "$dir" fetch
    fi
  done
}

# Pull all Git repositories in subfolders
function gpall {
  for dir in */; do
    if [ -d "$dir/.git" ]; then
      branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
      echo "$dir  $branch"
      git -C "$dir" pull
    fi
  done
}
