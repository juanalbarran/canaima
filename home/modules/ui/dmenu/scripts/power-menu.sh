#!/bin/sh

# Options
OPTS="  Shutdown\n  Reboot\n  Logout\n  Lock"

# Run dmenu
# -i = Case insensitive
# -p = Prompt label
# -l = Number of lines (4 options = 4 lines)
# Note: dmenu uses the colors defined in your config.h automatically
ACTION=$(echo -e "$OPTS" | dmenu -i -p "Power" -l 4)

# Handle Actions
case $ACTION in
    "  Shutdown")
        systemctl poweroff
        ;;
    "  Reboot")
        systemctl reboot
        ;;
    "  Lock")
        slock
        ;;
    "  Logout")
        # This works for Systemd/NixOS to kill the session
        loginctl terminate-user $USER
        ;;
esac
