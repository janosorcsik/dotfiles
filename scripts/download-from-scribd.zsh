#!/bin/zsh
# @raycast.schemaVersion 1
# @raycast.title Download Scribd
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "Scribd URL", "optional": true }

url="${1:-$(pbpaste)}"
doc_path="${url#*scribd.com}"
[[ "$doc_path" == "$url" || -z "$doc_path" ]] && { echo "Not a Scribd URL"; exit 1; }
open "https://scribd.vdownloaders.com${doc_path%%\?*}"
