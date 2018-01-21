source /usr/local/share/antigen/antigen.zsh

antigen bundle akoenig/npm-run.plugin.zsh
antigen bundle zuxfoucault/colored-man-pages_mod
antigen bundle lukechilds/zsh-better-npm-completion
antigen bundle molovo/tipz
antigen bundle Tarrasch/zsh-command-not-found
antigen bundle tarruda/zsh-autosuggestions
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship

antigen apply

SPACESHIP_KUBECONTEXT_SHOW=false
TIPZ_TEXT='💡'

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Autoload zsh functions.
autoload -U ~/.zsh/functions/*(:t)

if brew command command-not-found-init > /dev/null; then eval "$(brew command-not-found-init)"; fi

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
