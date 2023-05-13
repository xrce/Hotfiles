#!/usr/bin/env bash

screen="  Screen"
area="  Crop"
window="  Window"

rofi_cmd() { rofi -dmenu -theme-str 'listview {columns: 3; lines: 1;}' -theme-str 'mainbox {children: [ "message", "listview" ];}' -mesg "Screenshot" -theme control.rasi; }
run_rofi() { echo -e "$screen\n$area\n$window" | rofi_cmd; }

chosen="$(run_rofi)"
case ${chosen} in
    $screen)
		date=$(date | sed 's/ /-/g' | sed 's/--WIB/.png/g')
        dst=~/Pictures/Screenshots/$date
        grimshot save screen $dst && notify-send "❀ Screenshtd" "$date" -i $dst
        ;;
    $area)
		date=$(date | sed 's/ /-/g' | sed 's/--WIB/.png/g')
        dst=~/Pictures/Screenshots/$date
        grimshot save area $dst && notify-send "❀ Screenshtd" "$date" -i $dst
        ;;
    $window)
		date=$(date | sed 's/ /-/g' | sed 's/--WIB/.png/g')
        dst=~/Pictures/Screenshots/$date
        grimshot save window $dst && notify-send "❀ Screenshtd" "$date" -i $dst
        ;;
esac