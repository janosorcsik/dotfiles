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
  echo "Looking for remote-tracking merged branches..."
  merged_remotes=$(git branch -r --merged | grep -Ev '\*|main|master|develop|release|wikiMaster' | sed 's/origin\///')

  if [[ -n "$merged_remotes" ]]; then
    echo "The following remote branches would be deleted:"
    echo "$merged_remotes" | while read -r branch; do
      echo " $branch (remote merged)"
    done

    read -p "Delete these remote merged branches? (y/n) " confirm_remote
    if [[ "$confirm_remote" == [yY] ]]; then
      echo "$merged_remotes" | while read -r branch; do
        echo " Deleting $branch (remote)"
        git push --delete origin "$branch"
      done
    else
      echo "Remote branches were not deleted."
    fi
  else
    echo "No remote-tracking merged branches found."
  fi

  echo "Pruning references to deleted remote branches..."
  git fetch --prune

  echo "Looking for gone-tracking local branches..."
  gone_locals=$(git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}')

  if [[ -n "$gone_locals" ]]; then
    echo "The following local branches track deleted remote branches:"
    echo "$gone_locals" | while read -r branch; do
      echo " $branch (tracking deleted remote)"
    done

    read -p "Delete these local branches tracking deleted remotes? (y/n) " confirm_gone
    if [[ "$confirm_gone" == [yY] ]]; then
      echo "$gone_locals" | while read -r branch; do
        echo " Deleting $branch (local tracking deleted remote)"
        git branch -D "$branch"
      done
    else
      echo "Local branches tracking deleted remotes were not deleted."
    fi
  else
    echo "No local branches tracking deleted remotes found."
  fi

  echo "Looking for local orphan branches..."
  orphans=$(git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads | awk '$2 == "" {print $1}')

  if [[ -n "$orphans" ]]; then
    echo "The following local branches have no remote tracking:"
    echo "$orphans" | while read -r branch; do
      echo " $branch (orphan)"
    done

    read -p "Delete these local orphan branches? (y/n) " confirm_orphan
    if [[ "$confirm_orphan" == [yY] ]]; then
      echo "$orphans" | while read -r branch; do
        echo " Deleting $branch (orphan)"
        git branch -D "$branch"
      done
    else
      echo "Local orphan branches were not deleted."
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
