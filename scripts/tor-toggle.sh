#!/bin/bash

if archtorify --status 2>/dev/null | grep -q "Your system is configured to use Tor"; then
    pkexec archtorify --clearnet && notify-send "Tor AUS" "Clearnet wieder aktiv"
else
    pkexec archtorify --tor && notify-send "Tor AN" "Alles läuft jetzt über Tor"
fi

pkill -RTMIN+8 waybar   # Waybar sofort updaten, damit das Icon sofort wechselt
