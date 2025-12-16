#!/bin/bash

if archtorify --status 2>/dev/null | grep -q "Your system is configured to use Tor"; then
    echo '{"text": "TOR ON ", "class": "on"}'
else
    echo '{"text": "⚠ TOR OFF ", "class": "off"}'
fi
