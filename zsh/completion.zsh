# Add Homebrew completions to fpath
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$HOMEBREW_PREFIX/share/zsh-completions:${FPATH}"

autoload -Uz compinit
compinit -i

# Completion styling
zstyle ':completion:*' use-cache true
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
