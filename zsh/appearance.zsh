# Set LS_COLORS using vivid with Catppuccin Mocha theme
export LS_COLORS="$(vivid generate catppuccin-mocha)"

# Theme should be loaded late in the process
source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
