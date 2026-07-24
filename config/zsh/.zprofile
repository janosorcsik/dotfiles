# Set PATH, MANPATH, etc., for Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Telemetry opt-outs
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
export AZURE_CORE_COLLECT_TELEMETRY=0
export HOMEBREW_NO_ANALYTICS=1

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

# Tool paths
path+=(
  "$CARGO_HOME/bin"                                         # Rust
  "$GOPATH/bin"                                             # Go
  "$DOTNET_CLI_HOME/.dotnet/tools"                          # .NET SDK
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
)
export PATH

# OrbStack: command-line tools and integration
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
