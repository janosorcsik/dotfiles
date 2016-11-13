export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export HOMEBREW_BUILD_FROM_SOURCE=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/usr/local/Caskroom"

fpath=(
    /usr/local/share/zsh-completions
    /usr/local/share/zsh/site-functions
    ~/.zsh/functions
    $fpath
)

export NVM_DIR="$HOME/.nvm"
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh

nvm use default
