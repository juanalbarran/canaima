# home/modules/waybar/components/network/default.nix
{
  programs.waybar.settings.mainBar."network" = {
    interval = 5;

    format-wifi = " ";
    format-ethernet = "󰈀 ";
    format-disconnected = "󰤮 ";

    format-alt = "{icon} {ipaddr}";

    tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\nIP: {ipaddr}\nSpeed: {bandwidthDownBits} down";
    tooltip-format-ethernet = "Ethernet: {ifname}\nIP: {ipaddr}\nSpeed: {bandwidthDownBits} down";
    tooltip-format-disconnected = "Disconnected";

    format-icons = {
      wifi = " ";
      ethernet = "󰈀 ";
      disconnected = "󰤮 ";
    };
  };
}
