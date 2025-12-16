#!/bin/bash
set -e

echo "Installing custom Omarchy configuration..."

# Install required packages
echo "Installing packages: tor, archtorify..."
yay -S --needed --noconfirm tor archtorify

# Copy tor scripts
echo "Copying tor scripts..."
mkdir -p ~/.config/waybar
cp scripts/tor-status.sh ~/.config/waybar/tor-status.sh
cp scripts/tor-toggle.sh ~/.config/waybar/tor-toggle.sh
chmod +x ~/.config/waybar/tor-status.sh
chmod +x ~/.config/waybar/tor-toggle.sh

# Backup existing waybar configuration
CONFIG_FILE="$HOME/.config/waybar/config.jsonc"
STYLE_FILE="$HOME/.config/waybar/style.css"

if [ -f "$CONFIG_FILE" ]; then
    echo "Backing up existing waybar config..."
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup-$(date +%Y%m%d-%H%M%S)"
fi

if [ -f "$STYLE_FILE" ]; then
    echo "Backing up existing waybar style..."
    cp "$STYLE_FILE" "$STYLE_FILE.backup-$(date +%Y%m%d-%H%M%S)"
fi

# Add Tor module to waybar config if not already present
echo "Updating waybar configuration..."
python3 <<'PYTHON_SCRIPT'
import json
import re
import os
from pathlib import Path

config_file = Path.home() / ".config" / "waybar" / "config.jsonc"

# Read the file
if not config_file.exists():
    print(f"Config file not found: {config_file}")
    exit(1)

with open(config_file, 'r') as f:
    content = f.read()

# Check if custom/tor already exists
if '"custom/tor"' in content:
    print("Tor module already exists in config, skipping...")
else:
    print("Adding Tor module to waybar config...")

    # Remove comments for parsing (but keep original for later)
    json_content = re.sub(r'//.*', '', content)
    json_content = re.sub(r'/\*.*?\*/', '', json_content, flags=re.DOTALL)

    # Parse JSON
    try:
        config = json.loads(json_content)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        exit(1)

    # Add custom/tor to modules-right if not present
    if "modules-right" in config:
        if "custom/tor" not in config["modules-right"]:
            # Insert after group/tray-expander if it exists, otherwise at the beginning
            if "group/tray-expander" in config["modules-right"]:
                idx = config["modules-right"].index("group/tray-expander")
                config["modules-right"].insert(idx + 1, "custom/tor")
            else:
                config["modules-right"].insert(0, "custom/tor")

    # Find the position to insert the custom/tor module definition
    # Look for the last custom/* module definition
    tor_module = '''  "custom/tor": {
    "format": "{}",
    "exec": "~/.config/waybar/tor-status.sh",
    "return-type": "json",
    "interval": 3, // checkt alle 3 Sekunden den Status
    "on-click": "~/.config/waybar/tor-toggle.sh"
  },'''

    # Find a good insertion point - after "hyprland/workspaces" block
    workspaces_end = content.find('},', content.find('"hyprland/workspaces"'))
    if workspaces_end != -1:
        # Insert after the workspaces block
        insertion_point = workspaces_end + 3  # after '},\n'
        content = content[:insertion_point] + "\n" + tor_module + content[insertion_point:]
    else:
        print("Could not find insertion point for Tor module")
        exit(1)

    # Update modules-right in the original content
    # Find the modules-right array and add custom/tor
    modules_right_match = re.search(r'"modules-right":\s*\[(.*?)\]', content, re.DOTALL)
    if modules_right_match:
        modules_list = modules_right_match.group(1)
        # Check if custom/tor is already there
        if '"custom/tor"' not in modules_list:
            # Find group/tray-expander
            if '"group/tray-expander"' in modules_list:
                # Insert after it
                modules_list_updated = modules_list.replace(
                    '"group/tray-expander",',
                    '"group/tray-expander",\n    "custom/tor",'
                )
            else:
                # Insert at the beginning
                modules_list_updated = '\n    "custom/tor",' + modules_list

            content = content.replace(
                f'"modules-right": [{modules_list}]',
                f'"modules-right": [{modules_list_updated}]'
            )

    # Write back
    with open(config_file, 'w') as f:
        f.write(content)

    print("Tor module added to config.jsonc")

PYTHON_SCRIPT

# Add CSS styles for Tor module
echo "Updating waybar styles..."
if [ -f "$STYLE_FILE" ]; then
    # Check if tor styles already exist
    if grep -q "#custom-tor" "$STYLE_FILE"; then
        echo "Tor styles already exist in style.css, skipping..."
    else
        echo "Adding Tor styles to style.css..."
        cat >> "$STYLE_FILE" <<'EOF'

#custom-tor.on {
  background-color: #2e7d32;
  color: #ffffff;
  padding: 0 8px;
  margin: 0 7.5px;
}

#custom-tor.off {
  background-color: #c62828;
  color: #ffffff;
  padding: 0 8px;
  margin: 0 7.5px;
}
EOF
        echo "Tor styles added to style.css"
    fi
else
    echo "Creating new style.css..."
    cp waybar/style.css "$STYLE_FILE"
fi

# Restart waybar
echo "Restarting waybar..."
pkill waybar || true
sleep 1
waybar &

echo ""
echo "Installation complete!"
echo "Tor module added to waybar. Click to toggle Tor on/off."
echo ""
echo "Backups created:"
[ -f "$CONFIG_FILE.backup-"* ] && ls -t "$CONFIG_FILE.backup-"* 2>/dev/null | head -1
[ -f "$STYLE_FILE.backup-"* ] && ls -t "$STYLE_FILE.backup-"* 2>/dev/null | head -1
