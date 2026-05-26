#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/usr/local/bin:$PATH"

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

# Wofi layout constants — must match themes/templates/wofi.nix
FONT_SIZE=18         # * { font-size }
TEXT_MARGIN=5        # #text { margin }
WINDOW_PADDING=20    # window { padding }
OUTER_PADDING=10     # #outer-box { padding }
BORDER_WIDTH=2       # #outer-box { border }

# Helper to calculate height
get_height() {
    local line_count
    line_count=$(echo -e "$1" | wc -l)
    local row_h=$(( FONT_SIZE + TEXT_MARGIN * 2 ))
    local overhead=$(( (OUTER_PADDING + BORDER_WIDTH) * 2 ))
    echo $(( (line_count * row_h) + overhead ))
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
            swaylock
        fi
        ;;
    *"Logout") loginctl terminate-user "$USER" ;;
esac
