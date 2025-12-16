# Custom Omarchy Configuration

Meine persönlichen Omarchy-Anpassungen mit Tor-Integration für Waybar.

## Features

- Tor-Toggle in Waybar
  - Grüner Hintergrund wenn Tor AN
  - Roter Hintergrund mit Warndreieck wenn Tor AUS
  - Klick zum Umschalten zwischen Tor und Clearnet

## Installation

Eine Zeile zum Installieren:

```bash
git clone https://github.com/claudesoft/custom-omarchy.git ~/custom-omarchy && cd ~/custom-omarchy && ./install.sh
```

**Das Installationsskript ist nicht-destruktiv:**
- Erstellt automatisch Backups deiner bestehenden Waybar-Konfiguration
- Fügt nur das Tor-Modul hinzu, ohne deine anderen Einstellungen zu überschreiben
- Prüft, ob das Modul bereits existiert und überspringt es in dem Fall
- Fügt CSS-Styles nur hinzu, wenn sie noch nicht vorhanden sind

## Enthaltene Pakete

- `tor` - The Onion Router
- `archtorify` - Transparent proxy through Tor for Arch Linux

## Dateien

- `waybar/config.jsonc` - Waybar-Konfiguration mit Tor-Modul
- `waybar/style.css` - Waybar-Styling mit Tor-Farben (grün/rot)
- `scripts/tor-status.sh` - Skript zum Prüfen des Tor-Status
- `scripts/tor-toggle.sh` - Skript zum Umschalten zwischen Tor und Clearnet
- `install.sh` - Installationsskript

## Manuelle Installation

1. Pakete installieren:
   ```bash
   yay -S tor archtorify
   ```

2. Dateien kopieren:
   ```bash
   cp waybar/config.jsonc ~/.config/waybar/
   cp waybar/style.css ~/.config/waybar/
   cp scripts/*.sh ~/.config/waybar/
   chmod +x ~/.config/waybar/tor-*.sh
   ```

3. Waybar neu starten:
   ```bash
   pkill waybar && waybar &
   ```

## Nutzung

Klicke auf das Tor-Modul in der Waybar um zwischen Tor und Clearnet umzuschalten.
Das Modul zeigt:
- "TOR ON" mit grünem Hintergrund wenn Tor aktiv ist
- "⚠ TOR OFF" mit rotem Hintergrund wenn Clearnet aktiv ist
