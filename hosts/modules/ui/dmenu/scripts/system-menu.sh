#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

# Configuration
# Set your preferred terminal here (e.g., 'st', 'kitty', 'alacritty')
TERM_CMD="kitty"

# Define entries
declare -A MENU_OPS
MENU_OPS=(
    ["Applications"]="  Applications"
    ["Keybinds"]="  Keybinds"
    ["Sound"]="   Sound"
    ["Network"]="   Network"
    ["Power"]="   Power"
)

# Conditional Bluetooth Check
if [ -d "/sys/class/bluetooth" ] && [ "$(ls -A /sys/class/bluetooth)" ]; then
    MENU_OPS["Bluetooth"]="  Bluetooth"
fi

# Build the options string
OPTS="${MENU_OPS[Applications]}\n${MENU_OPS[Keybinds]}"

if [[ -v MENU_OPS[Bluetooth] ]]; then
    OPTS="$OPTS\n${MENU_OPS[Bluetooth]}"
fi

OPTS="$OPTS\n${MENU_OPS[Sound]}\n${MENU_OPS[Network]}\n${MENU_OPS[Power]}"

# Calculate line count dynamically for dmenu height
LINES=$(echo -e "$OPTS" | wc -l)

# Run dmenu
# -i = Case insensitive
# -l = Number of vertical lines
# -p = Prompt label
SELECTED=$(echo -e "$OPTS" | dmenu -i -l "$LINES" -p "System")

# Handle Selection
case "$SELECTED" in
    *"Applications")
        # Launches the standard dmenu application runner
        dmenu_run
        ;;
    *"Keybinds")
        # Adjust flags if your terminal is not kitty (e.g., st -c keybinds -e ...)
        $TERM_CMD --class keybinds -e keybinds
        ;;
    *"Bluetooth")
        $TERM_CMD --class bluetooth-tui -e bluetuith
        ;;
    *"Sound")
        $TERM_CMD --class pulsemixer -e pulsemixer
        ;;
    *"Network")
        $TERM_CMD --class nmtui-floating -e nmtui
        ;;
    *"Power")
        power-menu
        ;;
esac
