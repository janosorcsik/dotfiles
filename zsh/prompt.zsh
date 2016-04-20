# Initialize colors.
autoload -U colors
colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Autoload zsh functions.
autoload -U ~/.zsh/functions/*(:t)

# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

# Set the prompt.
function prompt_char {
        git branch >/dev/null 2>/dev/null && echo '➜' && return
        echo '$'
}
PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} \
at %{$fg[cyan]%}%m%{$reset_color%} \
in %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}\
$(prompt_git_info)%{$reset_color%}
$(prompt_char)%{$reset_color%}  '
