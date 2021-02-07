#!/bin/bash

_desktop="$(xdotool get_desktop)"
_tabbed="$(xdotool getactivewindow)"
[[ "$(xprop -id "$_tabbed" -f WM_CLASS 8s '\000$1\n' WM_CLASS |awk -v FS='\0' '{gsub("\"", "", $2); print $2}')" == "tabbed" ]] \
	|| _tabbed="$(xdotool search --desktop "$_desktop" --limit 1 --classname "tabbed_$_desktop")"

exec st -w "${_tabbed:-"$(/usr/local/bin/tabbed -cdn "tabbed_$_desktop")"}" "$@"
