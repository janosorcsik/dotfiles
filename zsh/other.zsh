if brew command command-not-found-init > /dev/null; then eval "$(brew command-not-found-init)"; fi

setopt FunctionArgZero

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root)

ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold,underline
ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=82,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=51,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=201,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=231,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=226,bold
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout


ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=yellow
ZSH_HIGHLIGHT_STYLES[alias]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=green
ZSH_HIGHLIGHT_STYLES[function]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=green
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=231,bold
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=green
ZSH_HIGHLIGHT_STYLES[path]=fg=yellow
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=220
ZSH_HIGHLIGHT_STYLES[path_approx]=fg=203
ZSH_HIGHLIGHT_STYLES[globbing]=fg=164
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=45
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=207
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=fg=84
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[assign]=none

autoload -U compinit && compinit

# force rehash if we don't find any completion
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1 # Because we didn't really complete anything
}

# forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _match

# colored completion - use my LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# more completers to use
zstyle ':completion:*' _ignored _approximate

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# menu if nb items > 2
zstyle ':completion:*' menu select=2

zstyle ":completion:*:descriptions" format "%B%d%b"
zstyle ':completion:*' group-name ''

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

setopt correct
