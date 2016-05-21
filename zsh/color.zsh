# Make color constants available.
autoload -U colors && colors
export TERM="xterm-256color"

export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

# man color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;2;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;46m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32;2;12m'
