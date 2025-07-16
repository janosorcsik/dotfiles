# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"
# Disable .NET CLI telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1
# Disable Azure Function telemetry
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
# Disable Azure CLI telemetry
export AZURE_CORE_COLLECT_TELEMETRY=0
# Disable AWS Serverless Application Model CLI telemetry
export SAM_CLI_TELEMETRY=0
# Disable Stripe CLI telemetry
export STRIPE_CLI_TELEMETRY_OPTOUT=1
# Disable Next telemetry
export NEXT_TELEMETRY_DISABLED=1

# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# Add node_modules/.bin to PATH
export PATH="./node_modules/.bin:${PATH}"

# Homebrew configurations
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
