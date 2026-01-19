#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
# Configuration
CONFIG="$HOME/.config/wofi/config-menu.conf"
STYLE="$HOME/.config/wofi/style.css"

# --- Helper Function to calculate height ---
get_height() {
    # Count lines. Note: wc -l usually counts newlines, so we ensure accurate counting
    local line_count
    line_count=$(echo -e "$1" | wc -l)
    # Formula: (lines * 32px per line) + 28px padding
    echo $(( (line_count * 32) + 28 ))
}

# -------------------------------------------
# Define entries as an Associative Array for safer logic (Bash 4.0+)
declare -A MENU_OPS
MENU_OPS=(
    ["Applications"]="  Applications"
    ["Keybinds"]="  Keybinds"
    ["Sound"]="   Sound"
    ["Network"]="   Network"
    ["Power"]="   Power"
)

# Conditional Bluetooth
if [ -d "/sys/class/bluetooth" ] && [ "$(ls -A /sys/class/bluetooth)" ]; then
    MENU_OPS["Bluetooth"]="  Bluetooth"
fi

OPTS="${MENU_OPS[Applications]}\n${MENU_OPS[Keybinds]}"

if [[ -v MENU_OPS[Bluetooth] ]]; then
    OPTS="$OPTS\n${MENU_OPS[Bluetooth]}"
fi

OPTS="$OPTS\n${MENU_OPS[Sound]}\n${MENU_OPS[Network]}\n${MENU_OPS[Power]}"

HEIGHT=$(get_height "$OPTS")

# Run Wofi
SELECTED=$(echo -e "$OPTS" | wofi \
    --conf "$CONFIG" \
    --style "$STYLE" \
    --height "$HEIGHT" \
    --cache-file /dev/null \
    --dmenu)

# Handle Selection
# We use case pattern matching with wildcards (*) to ignore the icons/spaces
case "$SELECTED" in
    *"Applications")
        wofi --show drun --height 450 --width 400
        ;;
    *"Keybinds")
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            kitty --class keybinds -e keybinds
        else
            foot -a keybinds keybinds
        fi
        ;;
    *"Bluetooth")
        # Same logic for terminal selection...
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            kitty --class bluetooth-tui -e bluetuith
        else
            foot -a bluetooth-tui -e bluetuith
        fi
        ;;
    *"Sound")
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            kitty --class pulsemixer -e pulsemixer
        else
            foot -a pulsemixer -e pulsemixer
        fi
        ;;
    *"Network")
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            kitty --class nmtui-floating -e nmtui
        else
            foot -a nmtui-floating -e nmtui
        fi
        ;;
    *"Power")
        power-menu
        ;;
esac

