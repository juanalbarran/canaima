# nixos/modules/ui/sway/default.nix
{pkgs, ...}: let
in {
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    light.enable = true;
  };
  security.polkit.enable = true;
  security.rtkit.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true; # Wayland reference portal (needed for screensharing)
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
