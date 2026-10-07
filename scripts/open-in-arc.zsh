#!/bin/zsh
# @raycast.schemaVersion 1
# @raycast.title Open in Arc
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "URL", "optional": true }

url="${1:-$(pbpaste)}"
[[ $url == http* ]] || { echo "Not a URL"; exit 1; }
open -a Arc "$url"
