# home/modules/kanshi/default.nix
{
  services.kanshi = {
    enable = true;
    settings = [
      {
        # Profile 1: Dual monitor (Monitor and Lid open)
        # Matches when both displays are connected
        profile.name = "dual-monitor";
        profile.outputs = [
          {
            criteria = "eDP-1";
            position = "0,0";
            mode = "1366x768";
          }
          {
            criteria = "HDMI-A-1";
            position = "1366,0";
            mode = "2560x1080";
          }
        ];
        profile.exec = ''
          echo "dual-monitor" > /tmp/kanshi-profile
          notify-send "Kanshi" "Perfil activo: 💻 + 🖥️ Dual monitor"
          hyprctl keyword workspace 1, monitor:eDP-1
          hyprctl keyword workspace 2, monitor:HDMI-A-1
          hyprctl keyword workspace 3, monitor:eDP-1
          hyprctl keyword workspace 4, monitor:HDMI-A-1
        '';
      }
      {
        # Profile 2: Docked (Lid closed with external monitor)
        # Matches when only the external monitor is available
        profile.name = "docked-clamshell";
        profile.outputs = [
          {
            criteria = "HDMI-A-1";
            position = "0,0";
            mode = "2560x1080";
          }
        ];
        profile.exec = ''
          echo "docked-clamshell" > /tmp/kanshi-profile
          notify-send "Kanshi" "Perfil activo: 🧳 Modo dock (solo monitor externo)"
          hyprctl keyword workspace 1, monitor:HDMI-A-1
          hyprctl keyword workspace 2, monitor:HDMI-A-1
        '';
      }
      {
        # Profile 3 "Laptop only" (Fallback)
        # Matches only when laptop display is available
        profile.name = "laptop-only";
        profile.outputs = [
          {
            criteria = "eDP-1";
            position = "0,0";
            mode = "1366x768";
          }
        ];
        profile.exec = ''
          echo "laptop-only" > /tmp/kanshi-profile
          notify-send "Kanshi" "Perfil activo: 💻 Solo laptop"
          hyprctl keyword workspace 1, monitor:eDP-1
          hyprctl keyword workspace 2, monitor:eDP-1
        '';
      }
    ];
  };
  systemd.user.services.kanshi = {
    Unit = {
      After = "graphical-session.target";
    };
  };
}
