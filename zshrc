# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="/usr/local/sbin:./node_modules/.bin:$PATH"

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

export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:";

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

zstyle ':completion:*:*:*:default' menu yes select

zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

alias cat="bat"

alias ls="exa -a --group-directories-first"

alias ll="exa -al --group-directories-first"

alias ..="cd .."

#Git
alias ga="git add"
alias gcl="git clone --recursive"
alias gcm="git commit --message"
alias gco="git checkout"
alias gd="git diff"
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
#alias bu="sh $HOME/.zsh/functions/update_brew.sh"

# NPM update
alias nu="npm install npm -g && npm update -g"

function bu {
  mas upgrade
  brew update
  brew upgrade --fetch-HEAD

  brew cu --all --yes --quiet --no-brew-update

  brew cleanup -s
  rm -rf "$(brew --cache)"

  brew bundle dump --global --force --describe --no-lock
}

function gitc {
  git branch -r --merged | grep -v '\*\|master\|main\|develop\|release' | sed 's/origin\///' | xargs -n 1 git push --delete origin

  git fetch --prune

  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D
}

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
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

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
