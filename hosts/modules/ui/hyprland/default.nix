# hosts/modules/ui/hyprland/default.nix
{pkgs, ...}: {
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    config.common.default = "*";
  };
  services = {
    # Login
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "juan";
      };
    };

    # Enable automatic login for the user
    getty.autologinUser = "juan";
  };
}
