#!/usr/bin/env bash

power_on() {
    if bluetoothctl show | grep -q "Powered: yes"; then return 0
    else return 1; fi
}

# Toggles power state
toggle_power() {
    if power_on; then bluetoothctl power off && notify-send " Bluetooth" "Status: Disabled"
    else
        if rfkill list bluetooth | grep -q 'blocked: yes'; then rfkill unblock bluetooth && sleep 3; fi
        bluetoothctl power on
        notify-send " Bluetooth" "Status: Enabled"
    fi
}

# Checks if a device is connected
device_connected() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | grep -q "Connected: yes"; then return 0
    else return 1; fi
}

# Prints a short string with the current bluetooth status
# Useful for status bars like polybar, etc.
print_status() {
    if power_on; then
        printf ""

        paired_devices_cmd="devices Paired"
        # Check if an outdated version of bluetoothctl is used to preserve backwards compatibility
        if (( $(echo "$(bluetoothctl version | cut -d ' ' -f 2) < 5.65" | bc -l) )); then paired_devices_cmd="paired-devices"; fi

        mapfile -t paired_devices < <(bluetoothctl $paired_devices_cmd | grep Device | cut -d ' ' -f 2)
        counter=0

        for device in "${paired_devices[@]}"; do
            if device_connected "$device"; then
                device_alias=$(bluetoothctl info "$device" | grep "Alias" | cut -d ' ' -f 2-)

                if [ $counter -gt 0 ]; then printf ", %s" "$device_alias"
                else printf " %s" "$device_alias"; fi

                ((counter++))
            fi
        done
        printf ""
    else echo ""; fi
}

if [[ $1 == "toggle" ]]; then toggle_power; fi

print_status