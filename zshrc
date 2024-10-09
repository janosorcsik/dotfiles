# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="./node_modules/.bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:${PATH}"

FPATH="$(brew --prefix)/share/zsh/site-functions:$(brew --prefix)/share/zsh-completions:${FPATH}"

autoload -Uz compinit
compinit

export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:"

zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"

zstyle ':completion:*:*:*:default' menu yes select

zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

alias cat="bat"

alias ls="eza -a --group-directories-first"

alias ll="eza -al --group-directories-first"

alias ..="cd .."

#Git
alias ga="git add"
alias gcl="git clone --recursive"
alias gcm="git commit --message"
alias gco="git checkout"
alias gd="git diff"
alias gf="git fetch"
alias gm="git merge"
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
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
function bu {
  mas upgrade
  brew update
  brew upgrade --fetch-HEAD

  brew cu --all --yes --quiet --no-brew-update

  brew cleanup -s
  rm -rf "$(brew --cache)"

  brew bundle dump --global --force --describe --no-lock
}

# NPM update
alias nu="npm install npm --location=global && npm update --location=global"

function gitc {
  git branch -r --merged | grep -v '\*\|master\|main\|develop\|release' | sed 's/origin\///' | xargs -n 1 git push --delete origin

  git fetch --prune

  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D
}

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

source $(brew --prefix)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh

HISTSIZE=5000                #How many lines of history to keep in memory
HISTFILE=$HOME/.zsh_history  #Where to save history to disk
SAVEHIST=$HISTSIZE           #Number of history entries to save to disk
setopt appendhistory         #Append history to the history file (no overwriting)
setopt sharehistory          #Share history across terminals
setopt incappendhistory      #Immediately append to the history file, not just when a term is killed
setopt histignorealldups     #Substitute commands in the prompt

# Turn off all beeps
unsetopt BEEP

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.catppuccin_mocha-zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_CTRL_T_OPTS="--preview='bat --style numbers,changes --color=always {} | head -500' --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up --no-height --no-reverse"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion