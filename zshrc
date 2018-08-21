export PATH="/usr/local/sbin:$PATH"

autoload -Uz compaudit compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -di
else
  compinit -dCi
fi

#forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# rehash if command not found (possibly recently installed)
zstyle ':completion:*' rehash true

# menu if nb items > 2
zstyle ':completion:*' menu select=2

alias ls="gls --color --group-directories-first"

# List all files colorized in long format
alias ll="ls -lhAFG"

# List all files colorized in long format, including dot files
alias la="ls -A"

alias cd..="cd .."
alias ..="cd.."

# Simple HTTP server
alias http="python -m SimpleHTTPServer"

# Colored grep
alias grep="grep --color=auto"

# Default Python:
alias python=python3
# Default pip:
alias pip=pip3

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Brew and Cask update
alias bu="sh ~/.zsh/functions/update_brew.sh"

# NPM update
alias nu="npm install npm -g && npm update -g"

# Remove Duplicates from the “Open With” Right-Click Menu in Mac OS X:
alias killdups='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user;killall Finder;echo "Open With has been rebuilt, Finder will relaunch"'

# Use alias with sudo
alias sudo='nocorrect sudo '

export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

source /usr/local/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship
SPACESHIP_PROMPT_ORDER=(
  dir
  git
  exec_time
  line_sep
  battery
  char
)

SPACESHIP_GIT_STATUS_PREFIX=" "
SPACESHIP_GIT_STATUS_ADDED="%F{yellow}+"
SPACESHIP_GIT_STATUS_UNTRACKED="%F{cyan}?"
SPACESHIP_GIT_STATUS_DELETED="%F{green}✘"
SPACESHIP_GIT_STATUS_MODIFIED="%F{green}!"
SPACESHIP_GIT_STATUS_SUFFIX=""

HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
