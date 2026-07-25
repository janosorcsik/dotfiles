# Add Homebrew completions to fpath
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$HOMEBREW_PREFIX/share/zsh-completions:${FPATH}"

# Keep the completion dump in the cache dir instead of $ZDOTDIR (this repo)
autoload -Uz compinit
zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
mkdir -p "${zcompdump:h}"
compinit -d "$zcompdump"
unset zcompdump

# Completion styling
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:*:*:default' menu yes select

# Completion formatting
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"

# Group completions under a common name
zstyle ':completion:*' group-name ''

# Carapace completions
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
source <(carapace _carapace)
