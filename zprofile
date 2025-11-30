# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Disable .NET CLI telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Disable Azure Function telemetry
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1

# Disable Azure CLI telemetry
export AZURE_CORE_COLLECT_TELEMETRY=0

# Homebrew configurations
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

# Add node_modules/.bin to PATH
export PATH="./node_modules/.bin:${PATH}"

# Add Rust tools
export PATH="$PATH:$HOME/.cargo/bin"

# Add Go tools
export PATH=$PATH:$HOME/go/bin

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"

# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
