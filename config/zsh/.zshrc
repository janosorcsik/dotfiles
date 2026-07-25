# Config files are numbered to control load order:
# - appearance before completion (list-colors reads LS_COLORS)
# - completion (compinit) before plugins (fzf completion needs it)
for config_file in "$ZDOTDIR"/config/*.zsh; do
  source "$config_file"
done
unset config_file

# zsh-syntax-highlighting must be sourced at the very end of .zshrc, after all
# widgets and keymaps are defined; it works by wrapping every existing widget.
# https://github.com/zsh-users/zsh-syntax-highlighting#faq
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
