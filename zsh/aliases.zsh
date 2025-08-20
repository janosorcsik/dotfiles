# Aliases - common commands
alias ls="eza -a --group-directories-first"
alias ll="eza -al --group-directories-first"
alias ..="cd .."
alias rm="trash"

# Git aliases
alias ga="git add"
alias gcl="git clone"
alias gcm="git commit --message"
alias gco="git checkout"
alias gd="git diff"
alias gf="git fetch"
alias gm="git merge"
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gnb="git checkout -b"
alias gpl="git pull"
alias gps="git push"
alias gs="git status --branch --short"

# macOS Finder aliases
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# NPM update alias
alias nu="npm i npm -g && npm up -g"
