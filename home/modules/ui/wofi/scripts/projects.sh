#!/bin/sh

# --- Configuration ---
TERMINAL="ghostty"
PROJECTS_DIR="$HOME/dev"
WOFI_CONFIG="$HOME/.config/wofi/projects-menu.conf"
WOFI="$HOME/.nix-profile/bin/wofi"
WAYLAND_APP_ID="com.mitchellh.ghostty"
X11_CLASS_NAME="ghostty"
VIM_PATH="$HOME/.nix-profile/bin/nvim-base"
BASH_PATH="$HOME/.nix-profile/bin/bash"

# --- Get the list of projects ---
selected_name=$(find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | \
    $WOFI --conf "$WOFI_CONFIG" --prompt "Projects:")

# --- Safety Check ---
if [ -z "$selected_name" ]; then
    exit 0
fi

selected_path="$PROJECTS_DIR/$selected_name"
session_name=$(echo "$selected_name" | tr . _)

# --- Check tmux session exists ---
# We check that exists a tmux session with the name of the project we choose, 
# if not, we create the session with a standard window called editor and we
# open vim in it.
# Also we check if the project contains a tmux file configuration, if not,
# then we create another window in the newly created session called console
if ! tmux has-session -t "$session_name" 2>/dev/null; then
    
    tmux new-session \
        -d -s "$session_name" \
        -c "$selected_path" \
        -n "editor" \
        "$VIM_PATH; exec $BASH_PATH"
    
    project_config="$selected_path/.tmux-init.conf"
    
    if [ -f "$project_config" ]; then
        SESSION="$session_name" . "$project_config"
    else
        tmux new-window \
            -t "$session_name" \
            -n "console" \
            -c "$selected_path" \
            "exec $BASH_PATH"

        tmux select-window -t "${session_name}:editor"
    fi
fi

# --- Launching the terminal ---
# We check if there is another instance of the terminal open, if there is
# another instance open then we focus that instance, if not, then we open a\
# instance.
# Because i use several window managers then we set a case for each of them
if tmux switch-client -t "$session_name" 2>/dev/null; then
    if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
        hyprctl dispatch focuwindow "class:^$WAYLAND_APP_ID$"
        hyprctl dispatch focuswindow "class:^ghostty$"
    elif [ -n "$SWAYSOCK" ]; then
        swaymsg "[app_id=\"$WAYLAND_APP_ID\"] focus"
    elif [ -n "$DISPLAY" ]; then
        if command -v wmctrl >/dev/null; then
            wmctrl -w -a "$X11_CLASS_NAME"
        fi
    fi
else

    # --- Attach the session ---
    $TERMINAL -e tmux attach-session -t "$session_name"
fi

