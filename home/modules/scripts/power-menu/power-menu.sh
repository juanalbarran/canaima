#!/usr/bin/env bash

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

# Helper to calculate height
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
        echo -e "$input_data" | "${MENU_CMD[@]}" --dmenu --prompt "Power Menu" --hide-search --height "$height_val" --width 300 --cache-file /dev/null --conf "$CONFIG" --style "$STYLE"
    else
        echo -e "$input_data" | "${MENU_CMD[@]}" -p "Power Menu"
    fi
}

OPTS="  Shutdown\n  Reboot\n  Logout\n  Lock"
HEIGHT=$(get_height "$OPTS")

# Run Menu dynamically
ACTION=$(run_menu "$OPTS" "$HEIGHT")

# Handle Actions
case $ACTION in
    *"Shutdown") systemctl poweroff ;;
    *"Reboot") systemctl reboot ;;
    *"Lock")
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            hyprlock
        else
            swaylock -C ~/.config/sway/lock_config
        fi
        ;;
    *"Logout") loginctl terminate-user "$USER" ;;
esac
