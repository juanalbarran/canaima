# home/modules/ui/wofi/scripts/power-menu.nix
{pkgs, ...}:
pkgs.writeShellScriptBin "power-menu" ''
  get_height() {
    line_count=$(echo -e "$1" | wc -l)
    echo $(( ($line_count * 32) + 28 ))
  }

  OPTS="  Shutdown\n  Reboot\n  Logout\n  Lock"
  HEIGHT=$(get_height "$OPTS")

  ACTION=$(echo -e "$OPTS" | ${pkgs.wofi}/bin/wofi \
    --dmenu \
    --prompt "Power Menu" \
    --hide-search \
    --height $HEIGHT \
    --width 300 \
    --cache-file /dev/null \
    --conf ${./../config-menu.conf} \
    --style ${./../style.css})

  case $ACTION in
    "  Shutdown") systemctl poweroff ;;
    "  Reboot") systemctl reboot ;;
    "  Lock")
      if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
        hyprlock
      else
        /usr/local/bin/swaylock -C ~/.config/sway/lock_config
      fi
      ;;
    "  Logout") loginctl terminate-user $USER ;;
  esac
''
