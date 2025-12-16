#!/bin/bash
set -e

echo "Installing custom Omarchy configuration..."

# Install required packages
echo "Installing packages: tor, archtorify..."
yay -S --needed --noconfirm tor archtorify

# Copy waybar configuration
echo "Copying waybar configuration..."
cp waybar/config.jsonc ~/.config/waybar/config.jsonc
cp waybar/style.css ~/.config/waybar/style.css

# Copy tor scripts
echo "Copying tor scripts..."
cp scripts/tor-status.sh ~/.config/waybar/tor-status.sh
cp scripts/tor-toggle.sh ~/.config/waybar/tor-toggle.sh
chmod +x ~/.config/waybar/tor-status.sh
chmod +x ~/.config/waybar/tor-toggle.sh

# Restart waybar
echo "Restarting waybar..."
pkill waybar || true
waybar &

echo "Installation complete!"
echo "Tor module added to waybar. Click to toggle Tor on/off."
