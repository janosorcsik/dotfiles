# List all files colorized in long format
alias ls="ls -hlFG"

# List all files colorized in long format, including dot files
alias la="ls -hlaFG"

alias cd..="cd .."
alias ..="cd .."

# Simple HTTP server
alias http="python -m SimpleHTTPServer"

# Enable aliases to be sudo’ed
alias sudo="sudo "

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
alias bu="brew file update; brew file cask_upgrade -C; brew file init"

# Mackup backup
alias mu="mackup backup"

# Atom update
alias au="apm update; apm clean; apm list --installed --bare > ~/.atom/packages.list "