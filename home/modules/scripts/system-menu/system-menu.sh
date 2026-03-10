#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

# --- Parameter Parser ---
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <menu_command> [menu_args...]"
  exit 1
fi

MENU_CMD=("$@")
MENU_PROG="$1"

# Configuration
CONFIG="$HOME/.config/wofi/config-menu.conf"
STYLE="$HOME/.config/wofi/style.css"

# --- Helper Function to calculate height ---
get_height() {
    local line_count
    line_count=$(echo -e "$1" | wc -l)
    echo $(( (line_count * 32) + 28 ))
}

# --- MENU WRAPPER FUNCTION ---
run_menu() {
    local input_data="$1"
    local height_val="$2"

    if [[ "$MENU_PROG" == *"wofi"* ]]; then
        echo -e "$input_data" | "${MENU_CMD[@]}" --conf "$CONFIG" --style "$STYLE" --height "$height_val" --cache-file /dev/null --dmenu
    else
        echo -e "$input_data" | "${MENU_CMD[@]}"
    fi
}

# -------------------------------------------
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

# Run Menu dynamically
SELECTED=$(run_menu "$OPTS" "$HEIGHT")

# Handle Selection
case "$SELECTED" in
    *"Applications")
        if [[ "$MENU_PROG" == *"wofi"* ]]; then
            "${MENU_CMD[@]}" --show drun --height 450 --width 400
        else
            # Fallback to standard app launcher convention (e.g., bemenu-run, wmenu-run)
            "${MENU_PROG}-run"
        fi
        ;;
    *"Keybinds")
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            kitty --class keybinds -e keybinds
        else
            foot -a keybinds keybinds
        fi
        ;;
    *"Bluetooth")
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
            kitty --class network -e gazelle
        else
            foot -a network -e gazelle
        fi
        ;;
    *"Power")
        # Call the standalone power menu script we are about to make, passing the same menu args!
        power-menu "${MENU_CMD[@]}"
        ;;
esac
