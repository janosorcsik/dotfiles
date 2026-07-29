# Update Homebrew packages and App Store apps
function bu {
  echo "🍺 Starting System Package Updates"
  echo "═════════════════════════════════════════════════════"

  echo "📱 Checking Mac App Store updates..."
  mas upgrade

  echo "🔄 Updating Homebrew formulae..."
  brew update

  echo "⬆️ Upgrading Homebrew packages..."
  brew upgrade --yes

  echo "🧹 Cleaning up Homebrew files..."
  brew cleanup

  echo "📦 Creating Brewfile snapshot of installed packages..."
  brew bundle dump --global --force

  echo "═════════════════════════════════════════════════════"
  echo "✨ System updates complete!"

  echo "📊 Current system status:"
  echo "• Homebrew: $(brew --version | head -n 1)"
  echo "• Packages: $(brew list --formula | wc -l | xargs) formula, $(brew list --cask | wc -l | xargs) casks"
  echo "• Brewfile: ~/.Brewfile"
}

# Check whether a directory is a git repository root (.git is a file in worktrees/submodules).
# Deliberately not `git rev-parse`, which walks up and reports true for any subdirectory.
function _git_repo {
  [[ -e "$1/.git" ]]
}

# One cleanup pass: list branches, confirm, delete. Shared by gclean's three passes.
# Usage: _gclean_pass <dir> <repo> <noun> <desc> <deleter-fn> <newline-separated-branches>
function _gclean_pass {
  local dir="$1" repo="$2" noun="$3" desc="$4" deleter="$5" branches="$6"
  local confirm branch

  if [[ -z "$branches" ]]; then
    echo "   ✅ No $desc found."
    return 0
  fi

  echo "   Found $desc:"
  for branch in ${(f)branches}; do
    echo "   • $branch"
  done

  echo -n "❓ Delete these $noun in '$repo'? (y/n) "
  read -r confirm
  if [[ "$confirm" != [yY] ]]; then
    echo "   ✅ Kept $noun."
    return 0
  fi

  for branch in ${(f)branches}; do
    echo "   ✂️ Deleting: $branch"
    "$deleter" "$dir" "$branch"
  done
}

function _gclean_drop_remote { git -C "$1" push --delete origin "$2" }
function _gclean_drop_local { git -C "$1" branch -D "$2" }

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
  local default_branch
  default_branch=$(git -C "$dir" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')
  default_branch="${default_branch:-main}"
  merged_remotes=$(git -C "$dir" for-each-ref --format='%(refname:strip=3)' \
    --merged "refs/remotes/origin/$default_branch" refs/remotes/origin |
    awk -v def="$default_branch" '$0 != "HEAD" && $0 != def && $0 != "master" && $0 != "develop"')

  _gclean_pass "$dir" "$current_repo" "remote merged branches" "merged remote branches" \
    _gclean_drop_remote "$merged_remotes"

  # 2. Local branches tracking deleted remotes
  echo "🔍 Checking for local branches tracking deleted remotes..."
  local gone_locals
  gone_locals=$(git -C "$dir" branch -vv | grep -v '^\*' | grep 'origin/.*: gone]' | awk '{print $1}')

  _gclean_pass "$dir" "$current_repo" "local branches" "local branches tracking deleted remotes" \
    _gclean_drop_local "$gone_locals"

  # 3. Orphan branches
  echo "🔍 Checking for local orphan branches..."
  local orphans
  orphans=$(git -C "$dir" for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads |
            awk -v current="$current_branch" '$2 == "" && $1 != current {print $1}')

  _gclean_pass "$dir" "$current_repo" "orphan branches" "orphan branches" \
    _gclean_drop_local "$orphans"

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
    _git_repo "$dir" && gclean "$dir"
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
    if _git_repo "$dir"; then
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
    if _git_repo "$dir"; then
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

  local staged_diff
  staged_diff=$(git diff --staged)
  if [[ -z "$staged_diff" ]]; then
    echo "❌ No staged changes. Use 'git add' first."
    return 1
  fi

  # Inline the diff instead of letting the model fetch it: saves a tool-call round
  # trip. --pure skips the rtk plugin and MCP servers, which this task never needs.
  # A small model is plenty for a one-line message; drop --model to use the default.
  local response
  if ! response=$(opencode run --pure --model anthropic/claude-haiku-4-5 \
    "Generate a short single-line English git commit message for this diff.
Output ONLY the commit message, nothing else!

$staged_diff"); then
    echo "❌ opencode failed."
    return 1
  fi

  print -z "gcm ${(qq)response}"
}

# Convert GitHub HTTPS remotes to SSH for all repos in subfolders
function gsshall {
  setopt localoptions nullglob
  local dir ssh_url current_url
  echo "🔄 Converting GitHub remotes to SSH"
  echo "═════════════════════════════════════════════════════"

  for dir in */; do
    if _git_repo "$dir"; then
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
    echo "ℹ️ No staged .cs or .csproj files."
    return 0
  fi

  repo_root=$(git rev-parse --show-toplevel)

  echo "🧹 Formatting staged files..."
  echo "═════════════════════════════════════════════════════"

  # --include resolves paths against the CWD, but git reports them relative to the
  # repo root, so run from there. The subshell keeps the caller's directory intact.
  ( cd "$repo_root" && dotnet format --include "${(@f)staged_files}" )

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
    echo "ℹ️ No staged .cs or .csproj files."
    return 0
  fi

  sln_file=$(find "$(git rev-parse --show-toplevel)" -maxdepth 1 \( -name "*.sln" -o -name "*.slnx" \) | head -1)
  if [ -z "$sln_file" ]; then
    echo "❌ No .sln or .slnx file found in repo root."
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
