# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Load zsh configuration from $XDG_CONFIG_HOME instead of $HOME
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Suppress zsh session files (macOS Terminal.app)
export SHELL_SESSIONS_DISABLE=1

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"

# .NET
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"

# Go
export GOPATH="$XDG_DATA_HOME/go"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
