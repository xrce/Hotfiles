#!/usr/bin/env bash

if [[ $1 == "connect" ]]; then
    echo -e "SSID : $2"
    read -p "Password : " wifi_password
    nmcli device wifi connect "$2" password "$wifi_password" | grep "successfully" && notify-send "直  Connected" "$2"
    exit
fi

# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

enabled="直  Enabled"
disabled="睊  Disabled"
prompt="Wifi Manager"

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then toggle=$enabled
elif [[ "$connected" =~ "disabled" ]]; then toggle=$disabled; fi

# Use rofi to select wifi network
if [[ $wifi_list != "" ]]; then chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -theme-str 'mainbox {children: [ "message", "listview" ];}' -mesg "$prompt" -theme control.rasi )
else chosen_network=$(echo -e "$toggle" | uniq -u | rofi -dmenu -i -selected-row 1 -theme-str 'window {width: 200px;}' -theme-str 'listview {columns: 1; lines: 1;}' -theme control.rasi ); fi

# Get name of connection
chosen_id=$(echo "${chosen_network:3}" | xargs)

if [[ "$chosen_network" == $disabled ]]; then nmcli radio wifi on
elif [[ "$chosen_network" == $enabled ]]; then nmcli radio wifi off
else
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") == "$chosen_id" ]]; then nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "直  Connected" "$chosen_id"
	else xterm -e "~/.config/rofi/wifi.sh connect '$chosen_id'"; fi
fi