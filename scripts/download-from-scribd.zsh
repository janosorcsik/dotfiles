#!/bin/zsh
# @raycast.schemaVersion 1
# @raycast.title Download Scribd
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "Scribd URL", "optional": true }

url="${1:-$(pbpaste)}"
[[ $url == *scribd.com/* ]] || { echo "Not a Scribd URL"; exit 1; }
open "https://scribd.vdownloaders.com/${${url#*scribd.com/}%%[?#]*}"
