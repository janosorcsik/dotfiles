# Load all configuration files
for config_file in "$ZDOTDIR"/config/*.zsh; do
  source "$config_file"
done
