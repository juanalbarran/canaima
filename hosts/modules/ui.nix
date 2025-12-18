# hosts/modules/ui.nix
{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Necessary for many 32-bit compatibility layers
  };
}
