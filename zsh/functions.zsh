# Update Homebrew packages and App Store apps
function bu {
  echo "🍺 Starting System Package Updates"
  echo "═════════════════════════════════════════════════════"

  # App Store updates
  echo "📱 Checking Mac App Store updates..."
  mas upgrade

  # Homebrew updates
  echo "🔄 Updating Homebrew formulae..."
  brew update

  echo "⬆️ Upgrading Homebrew packages..."
  brew upgrade --fetch-HEAD

  echo "🖥️ Upgrading Homebrew Casks (applications)..."
  brew cu --all --yes --quiet --no-brew-update

  echo "🧹 Cleaning up Homebrew files..."
  brew cleanup -s

  echo "🗑️ Removing Homebrew cache..."
  rm -rf "$(brew --cache)"

  echo "📦 Creating Brewfile snapshot of installed packages..."
  brew bundle dump --global --force --describe

  echo "═════════════════════════════════════════════════════"
  echo "✨ System updates complete!"

  # Display a summary
  echo "📊 Current system status:"
  echo "• Homebrew: $(brew --version | head -n 1)"
  echo "• Packages: $(brew list --formula | wc -l | xargs) formula, $(brew list --cask | wc -l | xargs) casks"
  echo "• Brewfile: ~/.Brewfile"
}

# Clean up Git branches safely with confirmations
function gclean {
  # Get current repo name and branch for display
  current_repo=$(basename "$(pwd)")
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  # Show clear header with repo info
  echo "🧹 Git Branch Cleanup: $current_repo ($current_branch)"
  echo "═════════════════════════════════════════════════════"

  # Verify we're in a git repo before proceeding
  if [ ! -d ".git" ]; then
    return 0
  fi

  # 1. Remote merged branches
  echo "🔍 Checking remote-tracking merged branches..."
  merged_remotes=$(git branch -r --merged main | grep -Ev '\*|main|master|develop|release' | sed 's/origin\///')

  if [[ -n "$merged_remotes" ]]; then
    echo "   Found merged remote branches:"
    echo "$merged_remotes" | while read -r branch; do
      echo "   • $branch"
    done

    echo -n "❓ Delete these remote merged branches in '$current_repo'? (y/n) "
    read confirm_remote
    if [[ "$confirm_remote" == [yY] ]]; then
      echo "$merged_remotes" | while read -r branch; do
        echo "   ✂️ Deleting remote branch: $branch"
        git push --delete origin "$branch"
      done
    else
      echo "   ✅ Remote branches were kept."
    fi
  else
    echo "   ✅ No remote-tracking merged branches found."
  fi

  # 2. Prune and check for local branches tracking deleted remotes
  echo "🔄 Pruning references to deleted remote branches..."
  git fetch --prune

  echo "🔍 Checking for local branches tracking deleted remotes..."

  gone_locals=$(git branch -vv | grep -v '^\*' | grep 'origin/.*: gone]' | awk '{print $1}')

  if [[ -n "$gone_locals" ]]; then
    echo "   Found local branches tracking deleted remotes:"
    echo "$gone_locals" | while read -r branch; do
      echo "   • $branch"
    done

    echo -n "❓ Delete these local branches in '$current_repo'? (y/n) "
    read confirm_gone
    if [[ "$confirm_gone" == [yY] ]]; then
      echo "$gone_locals" | while read -r branch; do
        echo "   ✂️ Deleting local branch: $branch"
        git branch -D "$branch"
      done
    else
      echo "   ✅ Local branches were kept."
    fi
  else
    echo "   ✅ No local branches tracking deleted remotes."
  fi

  # 3. Orphan branches
  echo "🔍 Checking for local orphan branches..."

  orphans=$(git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads |
            awk -v current="$current_branch" '$2 == "" && $1 != current {print $1}')

  if [[ -n "$orphans" ]]; then
    echo "   Found local branches with no remote tracking:"
    echo "$orphans" | while read -r branch; do
      echo "   • $branch"
    done

    echo -n "❓ Delete these orphan branches in '$current_repo'? (y/n) "
    read confirm_orphan
    if [[ "$confirm_orphan" == [yY] ]]; then
      echo "$orphans" | while read -r branch; do
        echo "   ✂️ Deleting orphan branch: $branch"
        git branch -D "$branch"
      done
    else
      echo "   ✅ Orphan branches were kept."
    fi
  else
    echo "   ✅ No orphan branches found."
  fi

  echo "═════════════════════════════════════════════════════"
  echo "✨ Git branch cleanup complete for $current_repo"
}

# Clean all Git repositories in subfolders
function gcleanall {
  for dir in */; do
    if [ -d "$dir/.git" ]; then
      # Get repo branch info
      branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
      echo "🔍 Checking repo: $dir ($branch)"

      echo -n "❓ Clean branches in '$dir'? (y/n) "
      read confirm
      if [[ "$confirm" == [yY] ]]; then
        # Change to directory and run the cleaning
        (cd "$dir" && gclean)
        echo ""
      else
        echo "   ⏩ Skipping $dir"
        echo ""
      fi
    fi
  done

  echo "✅ Finished cleaning all repositories"
}

# Fetch all Git repositories in subfolders
function gfall {
  echo "🔄 Fetching updates for all repositories"
  echo "═════════════════════════════════════════════════════"

  for dir in */; do
    if [ -d "$dir/.git" ]; then
      branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
      echo "• $dir ($branch)"
      git -C "$dir" fetch
    fi
  done

  echo "═════════════════════════════════════════════════════"
  echo "✅ Fetch complete for all repositories"
}

# Pull all Git repositories in subfolders
function gpall {
  echo "⬇️ Pulling updates for all repositories"
  echo "═════════════════════════════════════════════════════"

  for dir in */; do
    if [ -d "$dir/.git" ]; then
      branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
      echo "• $dir ($branch)"
      git -C "$dir" pull
    fi
  done

  echo "═════════════════════════════════════════════════════"
  echo "✅ Pull complete for all repositories"
}
