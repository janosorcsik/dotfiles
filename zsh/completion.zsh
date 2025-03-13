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
zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

# Carapace completions
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
source <(carapace _carapace)
