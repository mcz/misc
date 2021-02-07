#!/usr/bin/bash
if lsof "${XDG_RUNTIME_DIR}/mpv.socket" &>/dev/null
then
	echo 'loadfile '"$1"' append-play' | socat - "${XDG_RUNTIME_DIR}/mpv.socket"
else
	mpv --terminal=no --idle --force-window --input-ipc-server="${XDG_RUNTIME_DIR}/mpv.socket" "$1" & disown
fi
