#!/bin/zsh
# @raycast.schemaVersion 1
# @raycast.title Open Safari Page in Arc
# @raycast.mode silent
# @raycast.icon 🌐

url=$(osascript -e 'tell application "Safari" to URL of current tab of front window' 2>/dev/null)
[[ -n $url ]] || { echo "No Safari window open"; exit 1; }
open -a Arc "$url"
