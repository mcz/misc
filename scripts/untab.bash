#!/usr/bin/env bash

while true
do
	src="$(xdotool getwindowfocus -f)"
	[[ "$(xprop -id "$src" -f _NET_SUPPORTING_WM_CHECK 32i '\000$0\n' _NET_SUPPORTING_WM_CHECK |awk -v FS='\0' '{gsub("\"", "", $2); print $2}')" == "$src" ]] && exit 1
	[[ "$(xprop -id "$src" -f WM_CLASS 8s '\000$1\n' WM_CLASS |awk -v FS='\0' '{gsub("\"", "", $2); print $2}')" == "st-256color" ]] && break
	src="$(xdotool getwindowfocus)"
	[[ "$(xprop -id "$src" -f WM_CLASS 8s '\000$1\n' WM_CLASS |awk -v FS='\0' '{gsub("\"", "", $2); print $2}')" != "tabbed" ]] && break
	src="$(xwininfo -id "$src" -int -children | awk 'NR == 7 {print $1}')"
	[[ -z "$src" ]] && exit 1
	break
done

dest="$(xwininfo -int | awk '/xwininfo: Window id:/ {print $4}')"
root="$(xwininfo -int -root | awk '/xwininfo: Window id:/ {print $4}')"

xwininfo -int -children -id "$dest" | grep "$src" && { xdotool windowreparent "$src" "$root"; exit 0; } # cliked on parent tabbed window, so detach
[[ "$dest" = "$root" ]] && { xdotool windowreparent "$src" "$(/usr/local/bin/tabbed -cd)"; exit 0; } # clicked on root, so attach to new tabbed
[[ "$(xprop -id "$dest" -f WM_CLASS 8s '\000$1\n' WM_CLASS |awk -v FS='\0' '{gsub("\"", "", $2); print $2}')" == "tabbed" ]] && xdotool windowreparent "$src" "$dest"
exit 0
