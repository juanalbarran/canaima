#!/bin/sh

# --- Configuration ---
terminal="ghostty"
terminal_app_id="com.mitchellh.ghostty"

projects_path="$HOME/dev"
vim_path="$HOME/.nix-profile/bin/nvim-base"
bash_path="$HOME/.nix-profile/bin/bash"

wofi="$HOME/.nix-profile/bin/wofi"
wofi_config="$HOME/.config/wofi/projects-menu.conf"

# --- Get the list of projects ---
selected_name=$(find "$projects_path" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | \
    $wofi --conf "$wofi_config" --prompt "Projects:")

# --- Safety Check ---
if [ -z "$selected_name" ]; then
    exit 0
fi

selected_path="$projects_path/$selected_name"
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
        -n "editor" \
        -c "$selected_path" "$vim_path; exec $bash_path"
    tmux new-window \
        -t "$session_name" \
        -n "console" \
        -c "$selected_path" "exec $bash_path"
    tmux new-window \
        -t "$session_name" \
        -n "lazygit" \
        -c "$selected_path" "lazygit; exec $bash_path"
    
    project_config="$selected_path/.tmux-init.conf"
    
    if [ -f "$project_config" ]; then
        SESSION="$session_name" . "$project_config"
    else
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
        hyprctl dispatch focuswindow "class:^$terminal_app_id$"
    elif [ -n "$SWAYSOCK" ]; then
        swaymsg "[app_id=\"$terminal_app_id\"] focus"
    fi
else
    # --- Attach the session ---
    $terminal -e tmux attach-session -t "$session_name"
fi

