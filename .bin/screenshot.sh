#!/usr/bin/env bash

if [[ $1 == "extend" ]]; then
    ~/.config/rofi/screenshot.sh
else
    date=$(date | sed 's/ /-/g' | sed 's/--WIB/.png/g')
    dst=~/Pictures/Screenshots/$date
    grimshot save output $dst && notify-send "❀ Screenshtd" "$date" -i $dst
fi