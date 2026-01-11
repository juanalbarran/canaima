# home/modules/waybar/components/bluetooth/default.nix
{
  pkgs,
  config,
  lib,
  ...
}: let
  bluetoothCommand = "${pkgs.foot}/bin/foot -a bluetooth-tui -e ${pkgs.bluetuith}/bin/bluetuith";
in {
  config = lib.mkIf config.features.bluetooth {
    programs.waybar.settings.mainBar."bluetooth" = {
      interval = 30;
      format = "{icon}";
      format-connected = "{icon}";

      # Tooltip: Shows controller status and list of devices
      tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
      tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
      tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";

      format-icons = {
        "enabled" = " ";
        "disabled" = "󰂲";
        "connected" = " "; # A solid icon when connected
        "on" = "";
        "off" = "󰂲";
      };

      # Actions
      on-click = bluetoothCommand;
      # "on-click-right" = "rfkill toggle bluetooth"; # Optional: Quick toggle
    };
    home.packages = with pkgs; [
      bluetuith
    ];
  };
}
