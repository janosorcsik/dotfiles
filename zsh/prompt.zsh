# Allow for functions in the prompt.
setopt prompt_subst

# Autoload zsh functions.
autoload -U ~/.zsh/functions/*(:t)

source ~/.zsh/zsh-vcs-prompt/zshrc.sh
# prompt
ZSH_VCS_PROMPT_ENABLE_CACHING='true'

export PROMPT_INFO="\$(vcs_super_info)"

if [ -n "$SSH_TTY" ]; then
export PROMPT="%F{055}%n%f@%F{245}%m%f:%F{green}%~%f \
${PROMPT_INFO}
%F{red}%(!.#.$)%f "
else
export PROMPT="%F{magenta}%n%f@%F{yellow}%m%f:%F{green}%~%f \
${PROMPT_INFO}
%(!.#.$) "
fi
