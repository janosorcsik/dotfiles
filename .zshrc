#! /bin/zsh

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export HOMEBREW_BUILD_FROM_SOURCE=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

fpath=(
	/usr/local/share/zsh-completions
	/usr/local/share/zsh/site-functions
	$fpath
)

export NVM_DIR=$HOME/.nvm
[[ -s $(brew --prefix nvm)/nvm.sh ]] && source $(brew --prefix nvm)/nvm.sh

export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

# man color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;33;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'

alias ll="ls -lahFG"
alias ls="ls -hFG"

# mkdir and cd to it
mkc() {
	mkdir -p "$1" && cd "$1" || return 1
}

server() {
	port="${1-8000}"
	python -m SimpleHTTPServer "$port" &
	open "http://localhost:$port"
}

if brew command command-not-found-init > /dev/null; then eval "$(brew command-not-found-init)"; fi

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
ZSH_HIGHLIGHT_STYLES[command]='fg=blue'
ZSH_HIGHLIGHT_STYLES[precommand]='none'
ZSH_HIGHLIGHT_STYLES[commandseparator]='none'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=blue'
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[path_prefix]='none'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=green'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=green'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=red'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[assign]='none'

# Force rehash when command not found
_force_rehash() {
	(( CURRENT == 1 )) && rehash
	return 1
}

# forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _match _ignored _approximate

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# menu if nb items > 2
zstyle ':completion:*' menu select=2

autoload -Uz compinit
compinit
