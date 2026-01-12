# home/modules/ui/wofi/default.nix
{
  pkgs,
  lib,
  config,
  ...
}: let
  isHyprland = config.wayland.windowManager.enable;
  # 1. Define the Master Menu Script
  # This script generates the top-level menu and handles the logic for submenus
  system-menu = pkgs.writeShellScriptBin "system-menu" ''
    # --- Helper Function to calculate height ---
    get_height() {
      line_count=$(echo -e "$1" | wc -l)

      # Formula: (lines * 32px per line) + 12px vertical padding
      # Since you hid the search bar, we don't need a large base number.
      echo $(( ($line_count * 32) + 28 ))
    }
    # -------------------------------------------
    OPTS="  Applications\n  Keybinds"

    if [ -d "/sys/class/bluetooth" ] && [ "$(${pkgs.coreutils}/bin/ls -A /sys/class/bluetooth)" ]; then
        OPTS="$OPTS\n  Bluetooth"
    fi

    OPTS="$OPTS\n   Sound\n   Network\n   Power"

    HEIGHT=$(get_height "$OPTS")

    SELECTED=$(echo -e "$OPTS" | ${pkgs.wofi}/bin/wofi \
    --conf ${./config-menu.conf} \
    --style ${./style.css} \
    --height $HEIGHT \
    --cache-file /dev/null)

    case $SELECTED in
      "  Applications")
        ${pkgs.wofi}/bin/wofi --show drun --height 450 --width 400
        ;;

      "  Keybinds")
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            ${pkgs.kitty}/bin/kitty --class keybinds -e sh -c "$HOME/.nix-profile/bin/show-keybinds"
        else
            ${pkgs.foot}/bin/foot -a keybinds sh -c "$HOME/.nix-profile/bin/show-keybinds"
        fi
        ;;

      "  Bluetooth")
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            ${pkgs.kitty}/bin/kitty --class bluetooth-tui -e bluetuith
        else
            ${pkgs.foot}/bin/foot -a bluetooth-tui -e ${pkgs.bluetuith}/bin/bluetuith
        fi
        ;;

      "   Sound")
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            ${pkgs.kitty}/bin/kitty --class pulsemixer -e pulsemixer
        else
            ${pkgs.foot}/bin/foot -a pulsemixer -e ${pkgs.pulsemixer}/bin/pulsemixer
        fi
        ;;

      "   Network")
        if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            ${pkgs.kitty}/bin/kitty --class nmtui-floating -e nmtui
        else
            ${pkgs.foot}/bin/foot -a nmtui-floating -e nmtui
        fi
        ;;

      "   Power")
        # Simple Power Submenu
        OPTS="  Shutdown\n  Reboot\n  Logout\n  Lock"

        SUB_HEIGHT=$(get_height "$OPTS")

        ACTION=$(echo -e "$OPTS" | ${pkgs.wofi}/bin/wofi \
          --dmenu \
          --prompt "Power Menu" \
          --hide-search \
          --height $SUB_HEIGHT \
          --width 300 \
          --cache-file /dev/null \
          --conf ${./config-menu.conf})


        case $ACTION in
          "  Shutdown") systemctl poweroff ;;
          "  Reboot") systemctl reboot ;;
          "  Lock")
            if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
              hyprlock
            else
              /usr/local/bin/swaylock -C ~/.config/sway/lock_config
            fi
            ;;
          "  Logout") loginctl terminate-user $USER ;;
        esac
        ;;
    esac
  '';
in {
  home.packages = [
    system-menu # Adds our script to the path
  ];

  # Basic Wofi Configuration
  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      insentive = true; # Case insensitive search
      run-always_parse_args = true;
      run-cache_file = "/dev/null";
    };
    # We can point to a CSS file for styling
    style = builtins.readFile ./style.css;
  };
}
