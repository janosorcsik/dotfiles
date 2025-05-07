# Completion system - optimized to run once per day using modification time check
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Add Homebrew completions to fpath
FPATH="$BREW_PREFIX/share/zsh/site-functions:$BREW_PREFIX/share/zsh-completions:${FPATH}"

# Completion styling
# Completion styling settings
zstyle ':completion:*' use-cache true  # Enable caching for completion results to speed up repeated completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Enable case-insensitive matching for completion
zstyle ':completion:*:*:*:default' menu yes select  # Show a menu for completions and allow selecting one with the arrow keys

# Completion formatting
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'  # Customize the message format for completion
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'  # Format description lines to highlight them
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"  # Set the color scheme for completion listing

# Group completions under a common name (empty here, can be customized)
zstyle ':completion:*' group-name ''

# Carapace completions
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
source <(carapace _carapace)
