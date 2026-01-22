# home/modules/waybar/components/network/default.nix
{
  pkgs,
  config,
  ...
}: let
  isHyprland = config.wayland.windowManager.hyprland.enable;
  termCommand =
    if isHyprland
    then "${pkgs.kitty}/bin/kitty --class network -e ~/.nix-profile/bin/gazelle"
    else "${pkgs.foot}/bin/foot -a network -e ~/.nix-profile/bin/gazelle";
in {
  programs.waybar.settings.mainBar."network" = {
    interval = 5;

    format-wifi = " ";
    format-ethernet = "󰈀 ";
    format-disconnected = "󰤮 ";

    tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\nIP: {ipaddr}\nSpeed: {bandwidthDownBits} down";
    tooltip-format-ethernet = "Ethernet: {ifname}\nIP: {ipaddr}\nSpeed: {bandwidthDownBits} down";
    tooltip-format-disconnected = "Disconnected";

    format-icons = {
      wifi = " ";
      ethernet = "󰈀 ";
      disconnected = "󰤮 ";
    };
    on-click = termCommand;
  };
}
