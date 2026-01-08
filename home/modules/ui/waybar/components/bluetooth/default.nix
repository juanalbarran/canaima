# home/modules/waybar/components/bluetooth/default.nix
{pkgs, ...}: {
  programs.waybar.settings.mainBar."bluetooth" = {
    interval = 30;
    format = " ";
    format-disabled = "󰂲 "; # Crossed out icon
    format-connected = " {device_alias} ";
    format-connected-battery = " {device_alias} {device_battery_percentage}% ";

    # Tooltip: Shows controller status and list of devices
    tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
    tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
    tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
    tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";

    # Actions
    on-click = "blueman-manager"; # Opens the GUI manager
    # "on-click-right" = "rfkill toggle bluetooth"; # Optional: Quick toggle
  };
  home.packages = with pkgs; [
    blueman
  ];
}
