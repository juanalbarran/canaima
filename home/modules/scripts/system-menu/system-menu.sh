#!/usr/bin/env bash
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

# --- Parameter Parser ---
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <terminal> <terminal_app_id> <menu_command> [menu_args...]"
  exit 1
fi

TERMINAL="$1"
TERMINAL_APP_ID="$2"
MENU_CMD=("${@:3}")
MENU_PROG="${MENU_CMD[0]}"

# Configuration
CONFIG="$HOME/.config/wofi/config-menu.conf"
STYLE="$HOME/.config/wofi/style.css"

# Wofi layout constants — must match themes/templates/wofi.nix
FONT_SIZE=18         # * { font-size }
TEXT_MARGIN=5        # #text { margin }
WINDOW_PADDING=20    # window { padding }
OUTER_PADDING=15     # #outer-box { padding }
BORDER_WIDTH=2       # #outer-box { border }

# --- Helper Function to calculate height ---
get_height() {
    local line_count
    line_count=$(echo -e "$1" | wc -l)
    local row_h=$(( FONT_SIZE + TEXT_MARGIN * 2 ))
    local overhead=$(( (OUTER_PADDING + BORDER_WIDTH) * 2 ))
    echo $(( ((line_count + 1) * row_h) + overhead ))
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

term_exec() {
    local app_id="$1"; shift
    case "$TERMINAL" in
       foot)   "$TERMINAL" -a "$app_id" "$@" ;;
       kitty)  "$TERMINAL" --class "$app_id" -e "$@" ;;
       *)      "$TERMINAL" "$@" ;;
    esac
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
        keybinds
        ;;
    *"Bluetooth") term_exec bluetooth-tui bluetuith ;;
    *"Sound") term_exec pulsemixer pulsemixer ;;
    *"Network") term_exec network gazelle ;;
    *"Power")
        # Call the standalone power menu script we are about to make, passing the same menu args!
        power-menu "${MENU_CMD[@]}"
        ;;
esac
