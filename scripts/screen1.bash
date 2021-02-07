#!/bin/bash

[[ -n "$TABBED" ]] && exec env DISPLAY=:0.0 st -f "Inconsolata:pixelsize=30:antialias=true:autohint=false:hintstyle=hintfull" -g 174x44 -w "$TABBED" "$@"
