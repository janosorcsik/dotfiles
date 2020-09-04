export N_PREFIX=$HOME/.n
export PATH="/usr/local/sbin:./node_modules/.bin:$HOME/.dotnet/tools:$N_PREFIX/bin:$PATH"

fpath=($fpath /usr/local/share/zsh-completions)

autoload -Uz compinit
zmodload -i zsh/complist

_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C
else
  compinit -i
fi
unset _comp_files

eval `gdircolors -b`
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

zstyle ':completion:*:*:*:default' menu yes select

zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

alias cat="bat"

alias ls="gls --color=auto --group-directories-first --almost-all"

alias ll="ls -g --human-readable --no-group"

alias cd..="cd .."

#Git
alias ga="git add"
alias gcl="git clone --recursive"
alias gcm="git commit --message"
alias gco="git checkout"
alias gd="git diff --color | diff-so-fancy"
alias gfa="git fetch --all"
alias gm="git merge"
alias gnb="git checkout -b"
alias gpl="git pull --recurse-submodules"
alias gps="git push"
alias gs="git status --branch --short"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Brew and Cask update
alias bu="sh $HOME/.zsh/functions/update_brew.sh"

# NPM update
alias nu="npm install npm -g && npm update -g"

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

source /usr/local/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh

HISTSIZE=5000                #How many lines of history to keep in memory
HISTFILE=$HOME/.zsh_history  #Where to save history to disk
SAVEHIST=$HISTSIZE           #Number of history entries to save to disk
setopt appendhistory         #Append history to the history file (no overwriting)
setopt sharehistory          #Share history across terminals
setopt incappendhistory      #Immediately append to the history file, not just when a term is killed
setopt histignorealldups     #Substitute commands in the prompt

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U promptinit; promptinit
prompt pure
