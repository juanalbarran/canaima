# home/modules/ui/waybar/components/vpn/default.nix
{pkgs, ...}: {
  programs.waybar.settings.mainBar."custom/vpn" = {
    format = "{} 󰆧 ";
    exec = "vpn=$(nmcli -t -f name,type,state connection show --active | grep vpn | cut -d ':' -f 1 | head -n 1); [ -z \"$vpn\" ] && echo 'Off' || echo \"$vpn\"";

    format-placeholder = "Off";
    interval = 5;
    return-type = "";

    on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";

    on-click-right = "nmcli connection down $(nmcli -t -f name,type,state connection show --active | grep vpn | cut -d ':' -f 1)";

    tooltip = true;
  };
}
