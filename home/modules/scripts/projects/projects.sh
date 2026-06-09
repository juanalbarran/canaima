#!/bin/sh
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/usr/local/bin:$PATH"
# --- Parameter Parser ---
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <projects_path> <terminal_binary> <terminal_app_id> <menu_command> [menu_args...]"
    echo "Example: $0 \$HOME/dev ghostty com.mitchellh.ghostty wofi --dmenu --prompt 'Projects:'"
    exit 1
fi

projects_path="$1"
terminal="$2"
terminal_app_id="$3"

# shift 2 discard the first two arguments ($1 and $2).
# Now, "$@" contains only the meny command and its flags.
shift 3

# --- Configuration ---
vim_path="nvim-web"
bash_path="bash"
devenv_path="devenv"

current_path="$projects_path"

while true; do
    subdirs=$(find "$current_path" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -printf "%f\n")

    if [ -f "$current_path/devenv.nix" ] || [ -f "$current_path/.tmux-init.conf" ]; then
        current_name=$(basename "$current_path")
        selected_name=$(printf "%s\n%s" "$current_name" "$subdirs" | "$@")
    else
        current_name=""
        selected_name=$(echo "$subdirs" | "$@")
    fi

    # Safety check: exit if user press escape
    if [ -z "$selected_name" ]; then
        exit 0
    fi

    # User selected the current directory itself as the project
    if [ -n "$current_name" ] && [ "$selected_name" = "$current_name" ]; then
        selected_path="$current_path"
        break
    fi

    selected_path="$current_path/$selected_name"

    # check for .git directory or devenv.nix to identify a project directory
    if [ -d "$selected_path/.git" ] || [ -f "$selected_path/.tmux-init.conf" ] || [ -f "$selected_path/devenv.nix" ]; then
        break
    else
        current_path="$selected_path"
    fi
done

selected_path=$(realpath "$selected_path")
real_projects_path=$(realpath "$projects_path")

if [ "$selected_path" = "$real_projects_path" ]; then
    relative_path=$(basename "$selected_path")
else
    relative_path="${selected_path#$real_projects_path/}"
fi

session_name=$(echo "$relative_path" | tr '/' '_' | tr '.' '_')

# --- Check tmux session exists ---
# We check that exists a tmux session with the name of the project we choose, 
# if not, we create the session with a standard window called editor and we
# open vim in it.
# Also we check if the project contains a tmux file configuration, if not,
# then we create another window in the newly created session called console
if ! tmux has-session -t "$session_name" 2>/dev/null; then
    
    # tmux new-session \
    #     -d -s "$session_name" \
    #     -n "opencode" \
    #     -c "$selected_path" "opencode; exec $bash_path"
    tmux new-session \
        -d -s "$session_name" \
        -n "claudio" \
        -c "$selected_path" "claude; exec $bash_path" 
    tmux new-window \
        -t "$session_name" \
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

