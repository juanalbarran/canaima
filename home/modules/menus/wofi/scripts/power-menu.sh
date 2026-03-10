#!/bin/sh

# Configuration
CONFIG="$HOME/.config/wofi/config-menu.conf"
STYLE="$HOME/.config/wofi/style.css"

# Helper to calculate height
get_height() {
    line_count=$(echo -e "$1" | wc -l)
    echo $(( ($line_count * 32) + 28 ))
}

OPTS="  Shutdown\n  Reboot\n  Logout\n  Lock"
HEIGHT=$(get_height "$OPTS")

# Run Wofi
ACTION=$(echo -e "$OPTS" | wofi \
    --dmenu \
    --prompt "Power Menu" \
    --hide-search \
    --height $HEIGHT \
    --width 300 \
    --cache-file /dev/null \
    --conf "$CONFIG" \
    --style "$STYLE")

# Handle Actions
case $ACTION in
    "  Shutdown") systemctl poweroff ;;
    "  Reboot") systemctl reboot ;;
    "  Lock")
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            hyprlock
        else
            # Ensure swaylock is in your PATH or adjust this path
            swaylock -C ~/.config/sway/lock_config
        fi
        ;;
    "  Logout") loginctl terminate-user $USER ;;
esac
