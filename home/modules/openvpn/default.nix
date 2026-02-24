# home/modules/openvpn/default.nix
{pkgs, ...}: {
  home.packages = with pkgs; [
    networkmanager-openvpn
    networkmanagerapplet
    openvpn
  ];

  services.network-manager-applet.enable = true;
}
