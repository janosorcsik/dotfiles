export PATH=/usr/local/bin:/usr/local/sbin:~/.bin:$PATH
export HOMEBREW_BUILD_FROM_SOURCE=1
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

fpath=(
    /usr/local/share/zsh-completions
    /usr/local/share/zsh/site-functions
    ~/.zsh/functions
    $fpath
)

export NVM_DIR=$HOME/.nvm
[[ -s $(brew --prefix nvm)/nvm.sh ]] && source $(brew --prefix nvm)/nvm.sh
