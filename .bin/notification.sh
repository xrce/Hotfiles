#!/bin/sh
notif=$(cat ~/.bin/notification 2> /dev/null)
if [ "$notif" != "" ]; then echo "$notif "; echo "" > ~/.bin/notification; fi