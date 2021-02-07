#!/bin/bash
LC_ALL=C xmessage \
	-center \
	-title 'Shutdown Menu' \
	-buttons '(1) Nothing:0,(2) Shutdown:2,(3) Reboot:3,(4) Sleep:4,(5) Hibernate:5,(6) Logout:6,(7) Restart Openbox:7,(8) Reconfigure Openbox:8,(9) Lock:9' \
	-default '(2) Shutdown' \
	-timeout 5 \
	"What do you want to do?"
case "$?" in
	"2")
		shutdown now
		;;
	"3")
		reboot
		;;
	"4")
		systemctl suspend
		;;
	"5")
		systemctl hibernate
		;;
	"6")
		pkill -TERM openbox
		;;
	"7")
		pkill -USR1 openbox
		;;
	"8")
		pkill -USR2 openbox
		;;
	"9")
		slock
esac

