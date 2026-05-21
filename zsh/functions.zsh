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
# Optional argument: path to the repository (defaults to current directory)
function gclean {
  local dir="${1:-.}"
  local current_repo current_branch
  current_repo=$(basename "$(realpath "$dir")")

  # Verify we're in a git repo before proceeding
  if ! git -C "$dir" rev-parse --git-dir &>/dev/null; then
    echo "❌ Not a git repository"
    return 1
  fi

  current_branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
  echo "🧹 Git Branch Cleanup: $current_repo (${current_branch:-detached HEAD})"
  echo "═════════════════════════════════════════════════════"

  # 1. Remote merged branches
  echo "🔍 Checking remote-tracking merged branches..."
  git -C "$dir" fetch --prune
  local merged_remotes
  merged_remotes=$(git -C "$dir" branch -r --merged main | grep -Ev '\*|main|master|develop|release' | sed 's/origin\///')

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
        git -C "$dir" push --delete origin "$branch"
      done
    else
      echo "   ✅ Remote branches were kept."
    fi
  else
    echo "   ✅ No remote-tracking merged branches found."
  fi

  # 2. Local branches tracking deleted remotes
  echo "🔍 Checking for local branches tracking deleted remotes..."
  local gone_locals
  gone_locals=$(git -C "$dir" branch -vv | grep -v '^\*' | grep 'origin/.*: gone]' | awk '{print $1}')

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
        git -C "$dir" branch -D "$branch"
      done
    else
      echo "   ✅ Local branches were kept."
    fi
  else
    echo "   ✅ No local branches tracking deleted remotes."
  fi

  # 3. Orphan branches
  echo "🔍 Checking for local orphan branches..."
  local orphans
  orphans=$(git -C "$dir" for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads |
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
        git -C "$dir" branch -D "$branch"
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
  setopt localoptions nullglob
  local dir
  echo "🧹 Git Branch Cleanup for all repositories"
  echo "═════════════════════════════════════════════════════"

  for dir in */; do
    [ -d "$dir/.git" ] && gclean "$dir"
  done

  echo "═════════════════════════════════════════════════════"
  echo "✅ Cleanup complete for all repositories"
}

# Fetch all Git repositories in subfolders
function gfall {
  setopt localoptions nullglob
  local dir branch
  echo "🔄 Fetching updates for all repositories"
  echo "═════════════════════════════════════════════════════"

  for dir in */; do
    if [ -d "$dir/.git" ]; then
      branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
      echo "• $(basename "$dir") ($branch)"
      git -C "$dir" fetch
    fi
  done

  echo "═════════════════════════════════════════════════════"
  echo "✅ Fetch complete for all repositories"
}

# Pull all Git repositories in subfolders
function gpall {
  setopt localoptions nullglob
  local dir branch
  echo "⬇️ Pulling updates for all repositories"
  echo "═════════════════════════════════════════════════════"

  for dir in */; do
    if [ -d "$dir/.git" ]; then
      branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
      echo "• $(basename "$dir") ($branch)"
      git -C "$dir" pull
    fi
  done

  echo "═════════════════════════════════════════════════════"
  echo "✅ Pull complete for all repositories"
}

# Generate a git commit message using opencode AI
function gmg {
  if ! git rev-parse --git-dir &>/dev/null; then
    echo "❌ Not a git repository"
    return 1
  fi

  local diff_content
  diff_content=$(git diff --staged)

  if [ -z "$diff_content" ]; then
    echo "❌ No staged changes. Use 'git add' first."
    return 1
  fi

  local response
  response=$(opencode run "Generate a short single-line English git commit message based on the following git diff. Output ONLY the commit message, nothing else!

$diff_content")
  local exit_code=$?

  if [ $exit_code -ne 0 ]; then
    echo "❌ opencode failed."
    return 1
  fi

  echo "gcm \"$response\""
}

# Convert GitHub HTTPS remotes to SSH for all repos in subfolders
function gsshall {
  setopt localoptions nullglob
  local dir ssh_url current_url
  echo "🔄 Converting GitHub remotes to SSH"
  echo "═════════════════════════════════════════════════════"

  for dir in */; do
    if [ -d "$dir/.git" ]; then
      current_url=$(git -C "$dir" config --get remote.origin.url 2>/dev/null)

      if [[ "$current_url" == https://github.com/* ]]; then
        ssh_url="${current_url//https:\/\/github.com\//git@github.com:}"
        git -C "$dir" remote set-url origin "$ssh_url"
        echo "✅ $(basename "$dir") (converted)"
      elif [[ "$current_url" == git@github.com:* ]]; then
        echo "• $(basename "$dir") (already SSH)"
      fi
    fi
  done

  echo "═════════════════════════════════════════════════════"
  echo "✅ SSH conversion complete for all repositories"
}

# Format staged .cs/.csproj files with dotnet format
function fmt {
  local staged_files repo_root

  if ! git rev-parse --git-dir &>/dev/null; then
    echo "❌ Not a git repository"
    return 1
  fi

  staged_files=$(git diff --staged --name-only --diff-filter=AM | grep -E -i '\.(cs|csproj)$')
  if [ -z "$staged_files" ]; then
    echo "❌ No staged .cs or .csproj files."
    return 0
  fi

  repo_root=$(git rev-parse --show-toplevel)

  echo "🧹 Formatting staged files..."
  echo "═════════════════════════════════════════════════════"

  local -a include_args
  mapfile -t include_args <<< "$staged_files"
  dotnet format "$repo_root" --include "${include_args[@]}"

  echo "═════════════════════════════════════════════════════"
  echo "✨ Format complete! Stage the changes manually."
}

# Cleanup staged .cs/.csproj files with JetBrains jb cleanupcode
function jfmt {
  local staged_files sln_file

  if ! git rev-parse --git-dir &>/dev/null; then
    echo "❌ Not a git repository"
    return 1
  fi

  staged_files=$(git diff --staged --name-only --diff-filter=AM | grep -E -i '\.(cs|csproj)$')
  if [ -z "$staged_files" ]; then
    echo "❌ No staged .cs or .csproj files."
    return 0
  fi

  sln_file=$(find "$(git rev-parse --show-toplevel)" -maxdepth 1 -name "*.sln" | head -1)
  if [ -z "$sln_file" ]; then
    echo "❌ No .sln file found in repo root."
    return 1
  fi

  echo "🧹 Cleaning up staged files..."
  echo "═════════════════════════════════════════════════════"

  local include_mask
  include_mask=$(echo "$staged_files" | tr '\n' ';' | sed 's/;$//')
  jb cleanupcode "$sln_file" --include="$include_mask" --no-build

  echo "═════════════════════════════════════════════════════"
  echo "✨ Cleanup complete! Stage the changes manually."
}
