# Custom Omarchy Configuration

Personal Omarchy customizations with Tor integration for Waybar.

## Features

- Tor toggle in Waybar
  - Green background when Tor is ON
  - Red background with warning icon when Tor is OFF
  - Click to toggle between Tor and Clearnet

## Installation

One-liner installation:

```bash
git clone https://github.com/claudesoft/custom-omarchy.git ~/custom-omarchy && cd ~/custom-omarchy && ./install.sh
```

**The installation script is non-destructive:**
- Automatically creates backups of your existing Waybar configuration
- Only adds the Tor module without overwriting your other settings
- Checks if the module already exists and skips it in that case
- Appends CSS styles only if they don't already exist

## Included Packages

- `tor` - The Onion Router
- `archtorify` - Transparent proxy through Tor for Arch Linux

## Files

- `waybar/config.jsonc` - Waybar configuration with Tor module
- `waybar/style.css` - Waybar styling with Tor colors (green/red)
- `scripts/tor-status.sh` - Script to check Tor status
- `scripts/tor-toggle.sh` - Script to toggle between Tor and Clearnet
- `install.sh` - Installation script

## Manual Installation

1. Install packages:
   ```bash
   yay -S tor archtorify
   ```

2. Copy files:
   ```bash
   cp waybar/config.jsonc ~/.config/waybar/
   cp waybar/style.css ~/.config/waybar/
   cp scripts/*.sh ~/.config/waybar/
   chmod +x ~/.config/waybar/tor-*.sh
   ```

3. Restart Waybar:
   ```bash
   pkill waybar && waybar &
   ```

## Usage

Click on the Tor module in Waybar to toggle between Tor and Clearnet.
The module displays:
- "TOR ON" with green background when Tor is active
- "⚠ TOR OFF" with red background when Clearnet is active
