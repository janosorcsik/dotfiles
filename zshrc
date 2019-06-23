PATH="/usr/local/sbin:$PATH:./node_modules/.bin:$HOME/.dotnet/tools";

autoload -Uz compinit

setopt EXTENDEDGLOB
for dump in ~/.zcompdump(#qN.m1); do
  compinit
  if [[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]]; then
    zcompile "$dump"
  fi
done
unsetopt EXTENDEDGLOB
compinit -C

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

alias cat="bat"

alias ls="ls -G"

# List all files
alias la="ls -lhA"

alias cd..="cd .."

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

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

source /usr/local/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh

# Enable colors in zsh.
autoload colors && colors

# Enable colors in ls.
export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Set Spaceship ZSH as a prompt
autoload -U promptinit
promptinit
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
SPACESHIP_GIT_STATUS_ADDED="%F{yellow}+%F{red}"
SPACESHIP_GIT_STATUS_UNTRACKED="%F{cyan}?%F{red}"
SPACESHIP_GIT_STATUS_DELETED="%F{red}✗%F{red}"
SPACESHIP_GIT_STATUS_MODIFIED="%F{green}!%F{red}"
SPACESHIP_GIT_STATUS_AHEAD="%F{purple}↥%F{red}"
SPACESHIP_GIT_STATUS_BEHIND="%F{purple}↧%F{red}"
SPACESHIP_GIT_STATUS_DIVERGED="%F{purple}⇄%F{red}"
SPACESHIP_GIT_STATUS_SUFFIX=""

HISTSIZE=5000            #How many lines of history to keep in memory
HISTFILE=~/.zsh_history  #Where to save history to disk
SAVEHIST=5000            #Number of history entries to save to disk
setopt appendhistory     #Append history to the history file (no overwriting)
setopt sharehistory      #Share history across terminals
setopt incappendhistory  #Immediately append to the history file, not just when a term is killed
setopt histignorealldups #Substitute commands in the prompt

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
