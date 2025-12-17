# home/modules/kanshi/default.nix
{pkgs, ...}: {
  services.kanshi = {
    enable = true;
    settings = [
      {
        # --- Profile 1: Dual Monitor (Fully Dynamic) ---
        profile.name = "dual-monitor";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
          }
        ];
        profile.exec = ''
          ${pkgs.libnotify}/bin/notify-send "Kanshi" "Dual Monitor Detected"

          if [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
            # Sway specific workspace logic
            swaymsg workspace 1 output eDP-1
            swaymsg workspace 2 output HDMI-A-1
            swaymsg workspace 3 output eDP-1
            swaymsg workspace 4 output HDMI-A-1
          elif [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
            # Hyprland specific workspace logic
            hyprctl keyword workspace 1, monitor:eDP-1
            hyprctl keyword workspace 2, monitor:HDMI-A-1
            hyprctl keyword workspace 3, monitor:eDP-1
            hyprctl keyword workspace 4, monitor:HDMI-A-1
          fi
        '';
      }
      {
        # --- Profile 2: Docked / Clamshell ---
        profile.name = "docked-clamshell";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "0,0";
          }
        ];
        profile.exec = ''
          ${pkgs.libnotify}/bin/notify-send "Kanshi" "Docked Mode"

          if [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
             swaymsg workspace 1 output HDMI-A-1
             swaymsg workspace 2 output HDMI-A-1
          elif [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
             hyprctl keyword workspace 1, monitor:HDMI-A-1
             hyprctl keyword workspace 2, monitor:HDMI-A-1
          fi
        '';
      }
      {
        # --- Profile 3: Laptop Only ---
        profile.name = "laptop-only";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
          }
        ];
        profile.exec = ''
          ${pkgs.libnotify}/bin/notify-send "Kanshi" "Laptop Mode"

          if [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
             swaymsg workspace 1 output eDP-1
          elif [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
             hyprctl keyword workspace 1, monitor:eDP-1
          fi
        '';
      }
    ];
  };
}
