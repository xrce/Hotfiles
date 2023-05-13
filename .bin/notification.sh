#!/bin/sh
privacy=$(lsmod | grep uvcvideo | head -n 1 | awk '{print $3}')
player_status=$(playerctl -p spotify status 2> /dev/null)
if [ "$privacy" = "1" ]; then echo "  Camera used"
elif [ "$player_status" = "Playing" ]; then echo "  $(playerctl -p spotify metadata artist) - $(playerctl -p spotify metadata title)"
elif [ "$player_status" = "Paused" ]; then echo "  $(playerctl -p spotify metadata artist) - $(playerctl -p spotify metadata title)"
else echo ""; fi