#!/usr/bin/env bash
# Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
logout=' Logout'
yes='Yes'
no='No'

# Rofi CMD
rofi_cmd() { rofi -dmenu -theme-str 'listview {columns: 4; lines: 1;}' -theme control.rasi; }

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {width: 250px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme control.rasi
}

# Ask for confirmation
confirm_exit() { echo -e "$yes\n$no" | confirm_cmd; }

# Pass variables to rofi dmenu
run_rofi() { echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi_cmd; }

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then systemctl reboot
		elif [[ $1 == '--logout' ]]; then swaymsg exit; fi
	else exit 0; fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
		swaylock
        ;;
    $logout)
		run_cmd --logout
        ;;
esac