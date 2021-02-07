#!/bin/bash
(($(</sys/class/power_supply/BAT0/capacity) < 10)) && [[ "$(</sys/class/power_supply/BAT0/status)" = "Discharging" ]] && systemctl hibernate
:
