#!/bin/zsh
# @raycast.schemaVersion 1
# @raycast.title Open Finder Folder in Ghostty
# @raycast.mode silent
# @raycast.icon 👻

folder=$(osascript -e 'tell application "Finder" to POSIX path of (target of front Finder window as alias)' 2>/dev/null)
[[ -n $folder ]] || { echo "No Finder window open"; exit 1; }
open -a Ghostty "$folder"
