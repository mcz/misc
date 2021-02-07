#!/bin/bash
[[ "$(ls -A /media/)" ]] || { dunstify --icon=media-removable --urgency=low "No drives mounted"; exit; }

drive="/media/$({  echo "/Unmount All/"; ls -A /media/; } | dmenu -l 20)"
[[ "$drive" == "/media/" ]] && exit
[[ "$drive" == "/media//Unmount All/" ]] && { 
	dunst_id="$(dunstify -p --urgency=low --icon=media-removable "Devmon" "Unmounting all")"
	devmon -u | while read line
	do
		dunstify --urgency=low --icon=media-removable -r "$dunst_id" Devmon "${line#devmon: }"
		sleep 0.5
	done
	devmon_exit=${PIPESTATUS[0]}
} || {
	dunst_id="$(dunstify -p --urgency=low --icon=media-removable "Devmon" "Unmounting $drive")"
	devmon --unmount "$drive" | while read line
	do
		dunstify --urgency=low --icon=media-removable -r "$dunst_id" Devmon "${line#devmon: }"
		sleep 0.5
	done
}

[[ ${PIPESTATUS[0]} -ne 0 || $devmon_exit -ne 0 ]] && dunstify -t 2000 --urgency=critical --icon=media-removable -r "$dunst_id" Devmon "Error unmounting drive(s)" || dunstify -t 2000 --urgency=low --icon=media-removable -r "$dunst_id" Devmon "Drive(s) unmounted successfully"
