# Update Homebrew packages and App Store apps
function bu {
  echo "🍺 Updating apps and packages"
  echo "═════════════════════════════════════════════════════"

  echo "📱 Updating Mac App Store apps"
  mas upgrade

  echo "🔄 Updating Homebrew"
  brew update

  echo "⬆️ Upgrading Homebrew packages"
  brew upgrade --yes

  echo "🧹 Cleaning up Homebrew"
  brew cleanup

  echo "📦 Saving installed packages to the Brewfile"
  brew bundle dump --global --force

  echo "═════════════════════════════════════════════════════"
  echo "✨ Done"
}

# Run a command inside every Git repository in the subfolders
function _each_repo {
  local dir
  for dir in *(N/); do
    [[ -e "$dir/.git" ]] || continue
    echo "• $dir"
    ( cd "$dir" && "$@" )
  done
}

# True if a branch is merged into origin/<default>, including squash and rebase merges.
function _merged {
  local ref=$1 default=$2 base
  git merge-base --is-ancestor "$ref" "origin/$default" && return 0
  base=$(git merge-base "origin/$default" "$ref") || return 1
  [[ $(git cherry "origin/$default" $(git commit-tree "$ref^{tree}" -p "$base" -m _)) == -* ]]
}

# Delete stale branches in the current repo, asking before each one.
function gclean {
  local default current branch upstream reason reply

  git fetch --prune || return
  default=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
  default="${${default#origin/}:-main}"
  current=$(git rev-parse --abbrev-ref HEAD)

  # Local branches
  git for-each-ref refs/heads --format='%(refname:short) %(upstream)' |
  while read -r branch upstream; do
    [[ "$branch" == ($current|$default|master|develop) ]] && continue

    if git show-ref --quiet --verify "refs/remotes/origin/$branch"; then
      _merged "origin/$branch" "$default" || continue
      read -r "reply?❓ Delete local and remote '$branch'? Merged into $default. (y/n) " </dev/tty
      [[ "$reply" == [yY] ]] && git push --delete origin "$branch" && git branch -D "$branch"
      continue
    fi

    [[ -n "$upstream" ]] && reason="Deleted on remote" || reason="Never pushed"
    read -r "reply?❓ Delete local '$branch'? $reason. (y/n) " </dev/tty
    [[ "$reply" == [yY] ]] && git branch -D "$branch"
  done

  # Remote branches without a local copy
  git for-each-ref refs/remotes/origin --format='%(refname:strip=3)' |
  while read -r branch; do
    [[ "$branch" == (HEAD|$default|master|develop) ]] && continue
    git show-ref --quiet --verify "refs/heads/$branch" && continue
    _merged "origin/$branch" "$default" || continue

    read -r "reply?❓ Delete remote '$branch'? Merged into $default. (y/n) " </dev/tty
    [[ "$reply" == [yY] ]] && git push --delete origin "$branch"
  done
}

# Clean all Git repositories in subfolders
function gcleanall {
  echo "🧹 Cleaning branches in all repositories"
  echo "═════════════════════════════════════════════════════"

  _each_repo gclean

  echo "═════════════════════════════════════════════════════"
  echo "✅ Done"
}

# Fetch all Git repositories in subfolders
function gfall {
  echo "🔄 Fetching all repositories"
  echo "═════════════════════════════════════════════════════"

  _each_repo git fetch

  echo "═════════════════════════════════════════════════════"
  echo "✅ Done"
}

# Pull all Git repositories in subfolders (fast-forward only, never creates merge commits)
function gpall {
  echo "⬇️ Pulling all repositories"
  echo "═════════════════════════════════════════════════════"

  _each_repo git pull --ff-only

  echo "═════════════════════════════════════════════════════"
  echo "✅ Done"
}

# Generate a git commit message using opencode AI
function gmg {
  local response

  if git diff --staged --quiet; then
    echo "❌ No staged changes. Use 'git add' first."
    return 1
  fi

  # The diff goes in as a temp file, because a large diff can be too long for an argument.
  response=$(opencode run --model anthropic/claude-haiku-5-5 --file =(git diff --staged) \
    "Generate a short single-line English git commit message for the attached diff.
Output ONLY the commit message, nothing else!") || return 1

  print -z "gcm ${(qq)response}"
}

# Switch the origin remote of the current repo from GitHub HTTPS to SSH
function _origin_to_ssh {
  local url
  url=$(git remote get-url origin 2>/dev/null)
  [[ "$url" == https://github.com/* ]] && git remote set-url origin "git@github.com:${url#https://github.com/}"
}

# Convert GitHub HTTPS remotes to SSH for all repos in subfolders
function gsshall {
  echo "🔄 Switching GitHub remotes to SSH"
  echo "═════════════════════════════════════════════════════"

  _each_repo _origin_to_ssh

  echo "═════════════════════════════════════════════════════"
  echo "✅ Done"
}

# Format staged .cs/.csproj files with dotnet format
function fmt {
  local files=(${(f)"$(git diff --staged --name-only --diff-filter=AM -- ':(top)*.cs' ':(top)*.csproj')"})
  [[ -z "$files" ]] && { echo "ℹ️ No staged .cs or .csproj files."; return 0 }

  echo "🧹 Formatting staged files"
  echo "═════════════════════════════════════════════════════"

  # git prints paths relative to the repo root, so run dotnet format from there
  ( cd "$(git rev-parse --show-toplevel)" && dotnet format --include $files )

  echo "═════════════════════════════════════════════════════"
  echo "✨ Done. Stage the changes yourself."
}

# Cleanup staged .cs/.csproj files with JetBrains jb cleanupcode
function jfmt {
  local files=(${(f)"$(git diff --staged --name-only --diff-filter=AM -- ':(top)*.cs' ':(top)*.csproj')"})
  [[ -z "$files" ]] && { echo "ℹ️ No staged .cs or .csproj files."; return 0 }

  local sln=( "$(git rev-parse --show-toplevel)"/*.(sln|slnx)(N) )
  [[ -z "$sln" ]] && { echo "❌ No .sln or .slnx file found in repo root."; return 1 }

  echo "🧹 Cleaning up staged files"
  echo "═════════════════════════════════════════════════════"

  jb cleanupcode "$sln[1]" --include="${(j:;:)files}" --no-build

  echo "═════════════════════════════════════════════════════"
  echo "✨ Done. Stage the changes yourself."
}
